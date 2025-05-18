# Copyright (c) 2022-2025 Nicolas ROBERT.
# Distributed under MIT license. Please see LICENSE for details.
#
namespace eval ticklecharts {}

proc ticklecharts::critHList {args} {
    # Replace huddle::list
    #
    # Returns huddle list
    return [critHuddleTypeList $args]
}

proc ticklecharts::critJsonDump {huddle {offset "  "} {newline "\n"} {begin ""}} {
    # Replace huddle::jsondump
    #
    # Returns JSON
    return [critHuddleDump $huddle [list $offset $newline $begin]]
}

# Gets all types huddle tags (boolean, null, string...)
# huddle package should be loaded.
#
# Note : If a huddle type is added, it will not be supported, 
# additional changes are expected
#
foreach {key value} [array get ::huddle::types tagOfType*] {
    lappend ht  [format {"%s"} $value]
    lappend cht [format {{"%s","%s"}} $value $::huddle::types(isContainer:$value)]
}

set LENHTYPE   [llength $ht]
set HTYPE      [format {{%s}} [join $ht ", "]]
set CONTAINERH [format {{%s}} [join $cht ", "]]

# load critcl.
package require critcl

# Tcl version
set tcl_version [info tclversion]
if {($tcl_version eq "8.6") &&
    ([ticklecharts::vCompare [package present critcl] "3.3"] < 0)
} {
    critcl::tcl 8.6
}

if {([ticklecharts::vCompare $tcl_version "9.0"] >= 0) &&
    ([ticklecharts::vCompare [package present critcl] "3.3"] < 0)
} {
    error "'critcl' version 3.3 or higher is required with Tcl9."
}

# SIZEMAX definition for Tcl 8.6.
if {$tcl_version eq "8.6"} {
    set DEFSIZEMAX {
        #ifndef TCL_SIZE_MAX
            typedef int Tcl_Size;
            # define Tcl_GetSizeIntFromObj Tcl_GetIntFromObj
            # define Tcl_NewSizeIntObj Tcl_NewIntObj
            # define TCL_SIZE_MAX      INT_MAX
            # define TCL_SIZE_MODIFIER ""
        #endif
    }
} else {
    set DEFSIZEMAX "// Not required with Tcl9 or supported by critcl."
}

set critCmd [string map [list \
        "%LENHTYPE%"   $LENHTYPE \
        "%HTYPE%"      $HTYPE \
        "%CONTAINERH%" $CONTAINERH \
        "%DEFSIZEMAX%" $DEFSIZEMAX \
    ] {
        critcl::ccode {
            #include <stdio.h>
            #include <string.h>

            // SIZEMAX definition for Tcl 8.6.
            %DEFSIZEMAX%

            const char *HUDDLETYPE[%LENHTYPE%]    = %HTYPE%;
            const char *HCONTAINER[%LENHTYPE%][2] = %CONTAINERH%;
            int HUDDLETLEN                        = %LENHTYPE%;
            const char *HMAP[8][2] = {
                {"\n","\\n"},
                {"\t","\\t"},
                {"\r","\\r"}, 
                {"\b","\\b"}, 
                {"\f","\\f"}, 
                {"\\","\\\\"}, 
                {"\"","\\\""}, 
                {"/","\\/"}
            };

            Tcl_Obj* huddleTypeCallbackStripC      (Tcl_Interp* interp, Tcl_Obj* headobj, Tcl_Obj* srcobj);
            Tcl_Obj* huddleTypeCallbackGetSubNodeC (Tcl_Interp* interp, Tcl_Obj* headobj, Tcl_Obj* srcobj, Tcl_Obj* pathobj);
            Tcl_Obj* huddleStripNodeC              (Tcl_Interp* interp, Tcl_Obj* node);
            Tcl_Obj* huddleFindNodeC               (Tcl_Interp* interp, Tcl_Obj* node, Tcl_Obj* path);
            Tcl_Obj* huddleArgToNodeC              (Tcl_Interp* interp, Tcl_Obj* srcObj);
            Tcl_Obj* huddleUnwrapC                 (Tcl_Interp* interp, Tcl_Obj* huddle_object);
            int      isHuddleC                     (Tcl_Interp* interp, Tcl_Obj* huddle_object);
            /*
            *----------------------------------------------------------------------
            * mapWord --
            *----------------------------------------------------------------------
            */
            Tcl_Obj* mapWord(Tcl_Obj* strobj) {
                if (!strobj) {
                    return Tcl_NewStringObj("", -1);
                }

                const char* str = Tcl_GetString(strobj);

                // Counting hits to calculate size
                int cnt = 0;
                for (int i = 0; str[i] != '\0'; i++) {
                    for (int j = 0; j < 8; j++) {
                        if (str[i] == HMAP[j][0][0]) {
                            cnt++;
                            break;
                        }
                    }
                }

                // Allocate memory (size = length of str + cnt + 1)
                char* result = Tcl_Alloc(strlen(str) + cnt + 1);
                if (!result) {
                    return Tcl_NewStringObj("", -1);
                }

                // Build the new string
                int j = 0;
                for (int i = 0; str[i] != '\0'; i++) {
                    int replaced = 0;
                    for (int k = 0; k < 8; k++) {
                        if (str[i] == HMAP[k][0][0]) {
                            result[j++] = HMAP[k][1][0];
                            result[j++] = HMAP[k][1][1];
                            replaced = 1;
                            break;
                        }
                    }
                    if (!replaced) {
                        result[j++] = str[i];
                    }
                }
                result[j] = '\0';

                Tcl_Obj* obj = Tcl_NewStringObj(result, -1);
                Tcl_Free(result);
                return obj;
            }
            /*
            *----------------------------------------------------------------------
            * getObjFromClass --
            *----------------------------------------------------------------------
            */
            int getObjFromClass (Tcl_Interp* interp, Tcl_Obj* obj) {

                Tcl_Obj* cmd[2];
                Tcl_Obj* class[2];
                const char* str;
                int typeObj = 0;

                // Find type.
                class[0] = Tcl_NewStringObj("ticklecharts::typeOfClass", -1);
	            class[1] = obj;

                Tcl_IncrRefCount(class[0]);
                Tcl_IncrRefCount(class[1]);

                if (Tcl_EvalObjv(interp, 2, class, 0) != TCL_OK) {
                    Tcl_DecrRefCount(class[0]);
                    Tcl_DecrRefCount(class[1]);
                    Tcl_SetObjResult(
                        interp, 
                        Tcl_ObjPrintf("error(getObjFromClass): %s", 
                        Tcl_GetString(Tcl_GetObjResult(interp)))
                    );
                    return -1;
                }

                Tcl_DecrRefCount(class[0]);
	            Tcl_DecrRefCount(class[1]);

                str = Tcl_GetString(Tcl_GetObjResult(interp));

                // Get object value.
                cmd[0] = obj;

                if (!strcmp(str, "::ticklecharts::eString")) {
                    cmd[1] = Tcl_NewStringObj("get", -1);
                    typeObj = 1;
                } else if (!strcmp(str, "::ticklecharts::eStruct")) {
                    cmd[1] = Tcl_NewStringObj("structHuddle", -1);
                    typeObj = 2;
                } else {
                    Tcl_SetObjResult(
                        interp, 
                        Tcl_ObjPrintf("error(getObjFromClass):\
                        Object in 'list.d' should be 'eString' or 'eStruct' class.")
                    );
                    return -1;
                }

                Tcl_IncrRefCount(cmd[0]);
                Tcl_IncrRefCount(cmd[1]);

                if (Tcl_EvalObjv(interp, 2, cmd, 0) != TCL_OK) {
                    Tcl_DecrRefCount(cmd[0]);
                    Tcl_DecrRefCount(cmd[1]);
                    Tcl_SetObjResult(
                        interp,
                        Tcl_ObjPrintf("error(getObjFromClass): %s", 
                        Tcl_GetString(Tcl_GetObjResult(interp)))
                    );
                    return -1;
                }

                Tcl_DecrRefCount(cmd[0]);
	            Tcl_DecrRefCount(cmd[1]);

                return typeObj;
            }
            /*
            *----------------------------------------------------------------------
            * huddleTypeCallbackStripC --
            *----------------------------------------------------------------------
            */
            Tcl_Obj* huddleTypeCallbackStripC (Tcl_Interp* interp, Tcl_Obj* headobj, Tcl_Obj* srcobj) {

                Tcl_Size count, i;
                Tcl_Obj **elements;
                Tcl_Obj *resObj = Tcl_NewListObj (0,NULL);

                const char* head = Tcl_GetString(headobj);

                if (!strcmp(head, "D")) {
                    Tcl_SetObjResult(
                        interp,
                        Tcl_ObjPrintf("error(huddleTypeCallbackStripC):\
                        Dict Callback strip not supported.")
                    );
                    return NULL;

                } else if (!strcmp(head, "L")) {

                    if (Tcl_ListObjGetElements(interp, srcobj, &count, &elements) != TCL_OK) {
                        Tcl_SetObjResult(
                            interp,
                            Tcl_ObjPrintf("error(huddleTypeCallbackStripC): %s", 
                            Tcl_GetString(Tcl_GetObjResult(interp)))
                        );
                        return NULL;
                    }

                    for (i = 0; i < count; ++i) {
                        Tcl_Obj* stripped = huddleStripNodeC(interp, elements[i]);
                        if (stripped == NULL) return NULL;

                        Tcl_ListObjAppendElement(interp, resObj, stripped);
                    }

                } else {
                    Tcl_SetObjResult(
                        interp, 
                        Tcl_ObjPrintf("error(huddleTypeCallbackStripC):\
                        Callback Strip not supported.")
                    );
                    return NULL;
                }

                return resObj;
            }
            /*
            *----------------------------------------------------------------------
            * huddleTypeCallbackGetSubNodeC --
            *----------------------------------------------------------------------
            */
            Tcl_Obj* huddleTypeCallbackGetSubNodeC (Tcl_Interp* interp, Tcl_Obj* headobj, Tcl_Obj* srcobj, Tcl_Obj* pathobj) {

                Tcl_Obj* index_obj = NULL;
                Tcl_Size count, rc;

                const char* head = Tcl_GetString(headobj);

                if (!strcmp(head, "D")) {

                    if (Tcl_DictObjGet(interp, srcobj, pathobj, &index_obj) != TCL_OK) {
                        Tcl_SetObjResult(
                            interp,
                            Tcl_ObjPrintf("error(huddleTypeCallbackGetSubNodeC): %s", 
                            Tcl_GetString(Tcl_GetObjResult(interp)))
                        );
                        return NULL;
                    }

                } else if (!strcmp(head, "L")) {

                    if (Tcl_ListObjLength(interp, srcobj, &count) != TCL_OK) {
                        Tcl_SetObjResult(
                            interp,
                            Tcl_ObjPrintf("error(huddleTypeCallbackGetSubNodeC): %s", 
                            Tcl_GetString(Tcl_GetObjResult(interp)))
                        );
                        return NULL;
                    }
                    if (count == 0) {
                        Tcl_SetObjResult(
                            interp, 
                            Tcl_ObjPrintf("error(huddleTypeCallbackGetSubNodeC):\
                            List is empty.")
                        );
                        return NULL;
                    }

                    if (Tcl_GetSizeIntFromObj(interp, pathobj, &rc) != TCL_OK) {
                        Tcl_SetObjResult(
                            interp, 
                            Tcl_ObjPrintf("error(huddleTypeCallbackGetSubNodeC):\
                            Not possible to get integer from pathobj.")
                        );
                        return NULL;
                    }

                    Tcl_ListObjIndex(interp, srcobj, rc, &index_obj);

                } else {
                    Tcl_SetObjResult(
                        interp, 
                        Tcl_ObjPrintf("error(huddleTypeCallbackGetSubNodeC):\
                        Callback SubNode not supported.")
                    );
                    return NULL;
                }

                return index_obj;
            }
            /*
            *----------------------------------------------------------------------
            * infoTypeExistsC --
            *----------------------------------------------------------------------
            */
            int infoTypeExistsC (Tcl_Obj* objtype) {

                const char* type = Tcl_GetString(objtype);

                for (int i = 0; i < HUDDLETLEN; ++i) {
                    if (!strcmp(type, HUDDLETYPE[i])) {
                        return 1;
                    }
                }

                return 0;
            }
            /*
            *----------------------------------------------------------------------
            * isContainerC --
            *----------------------------------------------------------------------
            */
            int isContainerC (Tcl_Obj* objtype) {

                const char* src = Tcl_GetString(objtype);

                for (int i = 0; i < HUDDLETLEN; ++i) {
                    if (!strcmp(src, HCONTAINER[i][0])) {
                        if (!strcmp(HCONTAINER[i][1], "yes")) {
                            return 1;
                        } else {
                            return 0;
                        }
                    }
                }

                return 0;
            }
            /*
            *----------------------------------------------------------------------
            * isHuddleC --
            *----------------------------------------------------------------------
            */
            int isHuddleC (Tcl_Interp* interp, Tcl_Obj* huddle_object) {

                Tcl_Size count;
                Tcl_Obj **elements;

                if (Tcl_ListObjGetElements(interp, huddle_object, &count, &elements) != TCL_OK) {
                    Tcl_SetObjResult(
                        interp,
                        Tcl_ObjPrintf("error(isHuddleC): %s", 
                        Tcl_GetString(Tcl_GetObjResult(interp)))
                    );
                    return -1;
                }

                // if count == 0 Segmentation fault, for Tcl_GetString()
                if (count == 0) {
                    return 0;
                }

                const char* h = Tcl_GetString(elements[0]);

                if (strcmp(h, "HUDDLE") != 0 || count != 2) {
                    return 0;
                }

                Tcl_Obj* index_obj = NULL;

                if (Tcl_ListObjIndex(interp, elements[1], 0, &index_obj) != TCL_OK) {
                    Tcl_SetObjResult(
                        interp,
                        Tcl_ObjPrintf("error(isHuddleC): %s", 
                        Tcl_GetString(Tcl_GetObjResult(interp)))
                    );
                    return -1;
                }

                return infoTypeExistsC(index_obj);
            }
            /*
            *----------------------------------------------------------------------
            * huddleUnwrapC --
            *----------------------------------------------------------------------
            */
            Tcl_Obj* huddleUnwrapC (Tcl_Interp* interp, Tcl_Obj* huddle_object) {

                Tcl_Size count;
                Tcl_Obj **elements;

                if (Tcl_ListObjGetElements(interp, huddle_object, &count, &elements) != TCL_OK) {
                    Tcl_SetObjResult(
                        interp,
                        Tcl_ObjPrintf("error(huddleUnwrapC): %s", 
                        Tcl_GetString(Tcl_GetObjResult(interp)))
                    );

                    return NULL;
                }

                return elements[1];
            }
            /*
            *----------------------------------------------------------------------
            * huddleStripNodeC --
            *----------------------------------------------------------------------
            */
            Tcl_Obj* huddleStripNodeC (Tcl_Interp* interp, Tcl_Obj* node) {

                Tcl_Size count;
                Tcl_Obj **elements;
                Tcl_Obj* obj;

                if (Tcl_ListObjGetElements(interp, node, &count, &elements) != TCL_OK) {
                    Tcl_SetObjResult(
                        interp,
                        Tcl_ObjPrintf("error(huddleStripNodeC): %s", 
                        Tcl_GetString(Tcl_GetObjResult(interp)))
                    );
                    return NULL;
                }

                // head = elements[0]
                // src  = elements[1]

                if (!infoTypeExistsC(elements[0])) {
                    Tcl_SetObjResult(
                        interp,
                        Tcl_ObjPrintf("error(huddleStripNodeC): Type doesn't exist '%s'", 
                        Tcl_GetString(elements[0]))
                    );
                    return NULL;
                }

                if (!isContainerC(elements[0])) {
                    // not a container
                    obj = elements[1];
                } else {
                    obj = huddleTypeCallbackStripC(interp, elements[0], elements[1]);
                    if (obj == NULL) return NULL;
                }

                return obj;
            }
            /*
            *----------------------------------------------------------------------
            * huddleWrapC
            *----------------------------------------------------------------------
            */
            Tcl_Obj* huddleWrapC (Tcl_Interp* interp, Tcl_Obj* node) {

                Tcl_Obj *resObj = Tcl_NewListObj (0,NULL);

                Tcl_ListObjAppendElement(interp, resObj, Tcl_NewStringObj("HUDDLE", 6));
                Tcl_ListObjAppendElement(interp, resObj, node);

                return resObj;
            }
            /*
            *----------------------------------------------------------------------
            * huddleRetrieveHuddleC --
            *----------------------------------------------------------------------
            */
            Tcl_Obj* huddleRetrieveHuddleC (Tcl_Interp* interp, Tcl_Obj* huddle_object, Tcl_Obj* path, int stripped) {

                Tcl_Obj* node;
                Tcl_Obj* targetnode;
                Tcl_Obj* obj;

                int result = isHuddleC(interp, huddle_object);

                if (result == 0) {
                    Tcl_SetObjResult(
                        interp,
                        Tcl_ObjPrintf("error(huddleRetrieveHuddleC):\
                        'huddle_object' is not Huddle.")
                    );
                    return NULL;
                } else if (result == -1) {
                    return NULL;
                }

                // unwrap huddle_object
                node = huddleUnwrapC(interp, huddle_object);
                if (node == NULL) return NULL;

                // find node
                targetnode = huddleFindNodeC(interp, node, path);
                if (targetnode == NULL) return NULL;

                if (stripped == 1) {
                    obj = huddleStripNodeC(interp, targetnode);
                    if (obj == NULL) return NULL;
                } else {
                    obj = huddleWrapC(interp, targetnode);
                }

                return obj;
            }
            /*
            *----------------------------------------------------------------------
            * huddleFindNodeC --
            *----------------------------------------------------------------------
            */
            Tcl_Obj* huddleFindNodeC (Tcl_Interp* interp, Tcl_Obj* node, Tcl_Obj* path) {

                Tcl_Size count;
                Tcl_Obj **elements;
                Tcl_Obj **pathelements;
                Tcl_Obj* obj;

                Tcl_ListObjGetElements(interp, path, &count, &pathelements);

                if (count == 0) {
                    obj = node;
                } else {
                    Tcl_ListObjGetElements(interp, node, &count, &elements);
                    // fixed 'segmentation fault' when path (key) contains spaces. (v3.1.3)
                    obj = huddleTypeCallbackGetSubNodeC(interp, elements[0], elements[1], path);
                    if (obj == NULL) return NULL;
                }

                return obj;
            }
            /*
            *----------------------------------------------------------------------
            * huddleGetC --
            *----------------------------------------------------------------------
            */
            Tcl_Obj* huddleGetC (Tcl_Interp* interp, Tcl_Obj* huddle_object, Tcl_Obj* obj) {

                return huddleRetrieveHuddleC(interp, huddle_object, obj, 0);
            }
            /*
            *----------------------------------------------------------------------
            * huddleGetStrippedC --
            *----------------------------------------------------------------------
            */
            Tcl_Obj* huddleGetStrippedC (Tcl_Interp* interp,Tcl_Obj* huddle_object) {

                Tcl_Obj* obj = Tcl_NewObj();

                return huddleRetrieveHuddleC(interp, huddle_object, obj, 1);
            }
            /*
            *----------------------------------------------------------------------
            * huddleTypeC --
            *----------------------------------------------------------------------
            */
            Tcl_Obj* huddleTypeC (Tcl_Interp* interp, Tcl_Obj* huddle_object) {

                Tcl_Obj* node;
                Tcl_Size count;
                Tcl_Obj **elements;

                int result = isHuddleC(interp, huddle_object);

                if (result == 0) {
                    Tcl_SetObjResult(
                        interp,
                        Tcl_ObjPrintf("error(huddleTypeC):\
                        'huddle_object' is not Huddle.")
                    );
                    return NULL;
                } else if (result == -1) {
                    return NULL;
                }

                node = huddleUnwrapC(interp, huddle_object);
                if (node == NULL) return NULL;

                if (Tcl_ListObjGetElements(interp, node, &count, &elements) != TCL_OK) {
                    Tcl_SetObjResult(
                        interp,
                        Tcl_ObjPrintf("error(huddleTypeC): %s", 
                        Tcl_GetString(Tcl_GetObjResult(interp)))
                    );

                    return NULL;
                }

                return elements[0];
            }
            /*
            *----------------------------------------------------------------------
            * huddleLlengthC --
            *----------------------------------------------------------------------
            */
            Tcl_Size huddleLlengthC (Tcl_Interp* interp, Tcl_Obj* huddle_object) {

                Tcl_Obj* node;
                Tcl_Size count;
                Tcl_Obj **elements;
                Tcl_Obj **elementsrc;

                node = huddleUnwrapC(interp, huddle_object);
                if (node == NULL) return -1;

                if (Tcl_ListObjGetElements(interp, node, &count, &elements) != TCL_OK) {
                    Tcl_SetObjResult(
                        interp,
                        Tcl_ObjPrintf("error(huddleLlengthC): %s", 
                        Tcl_GetString(Tcl_GetObjResult(interp)))
                    );
                    return -1;
                }

                if (Tcl_ListObjGetElements(interp, elements[1], &count, &elementsrc) != TCL_OK) {
                    Tcl_SetObjResult(
                        interp,
                        Tcl_ObjPrintf("error(huddleLlengthC): %s", 
                        Tcl_GetString(Tcl_GetObjResult(interp)))
                    );
                    return -1;
                }

                return count;
            }
            /*
            *----------------------------------------------------------------------
            * huddleGetSrcC --
            *----------------------------------------------------------------------
            */
            Tcl_Obj* huddleGetSrcC (Tcl_Interp* interp, Tcl_Obj* huddle_object) {

                Tcl_Obj* node;
                Tcl_Size count;
                Tcl_Obj **elements;

                node = huddleUnwrapC(interp, huddle_object);

                if (node == NULL) return NULL;

                if (Tcl_ListObjGetElements(interp, node, &count, &elements) != TCL_OK) {
                    Tcl_SetObjResult(
                        interp,
                        Tcl_ObjPrintf("error(huddleGetSrcC): %s", 
                        Tcl_GetString(Tcl_GetObjResult(interp)))
                    );
                    return NULL;
                }

                return elements[1];
            }
            /*
            *----------------------------------------------------------------------
            * huddleDictKeysC --
            *----------------------------------------------------------------------
            */
            Tcl_Obj* huddleDictKeysC (Tcl_Interp* interp, Tcl_Obj* huddle_object) {

                Tcl_Obj* node;
                Tcl_Size count, i;
                Tcl_Obj **elements;
                Tcl_Obj *dict = Tcl_NewDictObj();

                node = huddleGetSrcC(interp, huddle_object);

                if (node == NULL) return NULL;

                if (Tcl_ListObjGetElements(interp, node, &count, &elements) != TCL_OK) {
                    Tcl_SetObjResult(
                        interp,
                        Tcl_ObjPrintf("error(huddleDictKeysC): %s", 
                        Tcl_GetString(Tcl_GetObjResult(interp)))
                    );
                    return NULL;
                }

                if (count % 2) {
                    Tcl_SetObjResult(
                        interp,
                        Tcl_ObjPrintf("error(huddleDictKeysC):\
                        List must have an even number of elements.")
                    );
                    return NULL;
                }

                for (i = 0; i < count; i+=2) {
                    Tcl_DictObjPut(interp, dict, elements[i], elements[i+1]);
                }

                return dict;
            }
            /*
            *----------------------------------------------------------------------
            * huddleJoinListC --
            *----------------------------------------------------------------------
            */
            Tcl_Obj* huddleJoinListC (Tcl_Interp* interp, Tcl_Obj* huddle_object, Tcl_Obj* nlof) {

                Tcl_Obj **elements;
                Tcl_Obj *joinObjPtr = Tcl_NewStringObj(",", 1);
                Tcl_Obj *resObjPtr  = Tcl_NewObj();
                Tcl_Size count, i;

                if (Tcl_ListObjGetElements(interp, huddle_object, &count, &elements) != TCL_OK) {
                    Tcl_SetObjResult(
                        interp,
                        Tcl_ObjPrintf("error(huddleJoinListC): %s", 
                        Tcl_GetString(Tcl_GetObjResult(interp)))
                    );
                    return NULL;
                }

                if (count == 1) {
                    return elements[0];
                }

                Tcl_AppendObjToObj(joinObjPtr, nlof);

                for (i = 0; i < count; i++) {
                    if (i > 0) {
                        Tcl_AppendObjToObj(resObjPtr, joinObjPtr);
                    }
                    Tcl_AppendObjToObj(resObjPtr, elements[i]);
                }

                return resObjPtr;
            }
            /*
            *----------------------------------------------------------------------
            * huddleArgToNodeC --
            *----------------------------------------------------------------------
            */
            Tcl_Obj* huddleArgToNodeC (Tcl_Interp* interp, Tcl_Obj* srcObj) {

                Tcl_Obj* defaultTag = Tcl_NewObj();
                Tcl_Obj* s = Tcl_NewStringObj("s", 1);

                int result = isHuddleC(interp, srcObj);

                if (result == -1) return NULL;

                if (result) {
                    defaultTag = huddleUnwrapC(interp, srcObj);
                    if (defaultTag == NULL) return NULL;
                } else {
                    Tcl_ListObjAppendElement(interp, defaultTag, s);
                    Tcl_ListObjAppendElement(interp, defaultTag, srcObj);
                }

                return defaultTag;
            }
            /*
            *----------------------------------------------------------------------
            * huddleJsonDumpC --
            *----------------------------------------------------------------------
            */
            Tcl_Obj* huddleJsonDumpC (Tcl_Interp* interp, Tcl_Obj* huddle_object, Tcl_Obj* huddle_format) {

                Tcl_Obj* dataobj = Tcl_NewObj();
                Tcl_Obj* nextoff = Tcl_NewObj();
                Tcl_Obj* subobject;
                Tcl_Obj **elements;
                Tcl_Size count, len, llen, i;
                int done;

                // huddle format.
                if (Tcl_ListObjGetElements(interp, huddle_format, &count, &elements) != TCL_OK) {
                    Tcl_SetObjResult(
                        interp,
                        Tcl_ObjPrintf("error(huddleJsonDumpC): %s", 
                        Tcl_GetString(Tcl_GetObjResult(interp)))
                    );
                    return NULL;
                }

                if (count != 3) {
                    Tcl_SetObjResult(
                        interp,
                        Tcl_ObjPrintf("error(huddleJsonDumpC):\
                        'huddle_format' should be a list of 3 elements.")
                    );
                    return NULL;
                }

                Tcl_GetStringFromObj(elements[0], &len);
                char *sp = " ";

                if (len == 0) {sp = "";}

                // nextoff > $begin$offset
                Tcl_AppendObjToObj(nextoff, elements[2]);
                Tcl_AppendObjToObj(nextoff, elements[0]);

                Tcl_Obj* htc = huddleTypeC(interp, huddle_object);

                if (htc == NULL) return NULL;

                const char *type = Tcl_GetString(htc);

                if (!strcmp(type, "b")) {
                    // boolean
                    return huddleGetStrippedC(interp, huddle_object);

                } else if (!strcmp(type, "num")) {
                    // number
                    return huddleGetStrippedC(interp, huddle_object);

                } else if (!strcmp(type, "s")) {

                    // string
                    Tcl_Obj* q = Tcl_NewStringObj("\"", 1);
                    Tcl_Obj* hstripped = huddleGetStrippedC(interp, huddle_object);

                    if (hstripped == NULL) return NULL;

                    Tcl_AppendObjToObj(dataobj, q);
                    Tcl_AppendObjToObj(dataobj, mapWord(hstripped));
                    Tcl_AppendObjToObj(dataobj, q);

                    return dataobj;

                } else if (!strcmp(type, "null")) {
                    // null
                    return Tcl_ObjPrintf("null");

                } else if (!strcmp(type, "L")) {
                    // list
                    len = huddleLlengthC(interp, huddle_object);
                    if (len == -1) return NULL;

                    Tcl_Obj *innerObj  = Tcl_NewListObj (0,NULL);
                    Tcl_Obj *formatObj = Tcl_NewListObj (0,NULL);

                    // offset newline nextoff
                    Tcl_ListObjAppendElement(interp, formatObj, elements[0]);
                    Tcl_ListObjAppendElement(interp, formatObj, elements[1]);
                    Tcl_ListObjAppendElement(interp, formatObj, nextoff);

                    for (i = 0; i < len; ++i) {
                        subobject = huddleGetC(interp, huddle_object, Tcl_NewSizeIntObj(i));
                        if (subobject == NULL) return NULL;
                        // recursive JsonDump
                        dataobj = huddleJsonDumpC(interp, subobject, formatObj);
                        if (dataobj == NULL) return NULL;
                        Tcl_ListObjAppendElement(interp, innerObj, dataobj);
                    }

                    if (Tcl_ListObjLength(interp, innerObj, &llen) != TCL_OK) {
                        Tcl_SetObjResult(
                            interp,
                            Tcl_ObjPrintf("error(huddleJsonDumpC): %s", 
                            Tcl_GetString(Tcl_GetObjResult(interp)))
                        );
                        return NULL;
                    }

                    if (llen == 1) {
                        Tcl_Obj* index_obj = NULL;
                        Tcl_ListObjIndex(interp, innerObj, 0, &index_obj);
                        return Tcl_ObjPrintf("[%s]", Tcl_GetString(index_obj));
                    }

                    // nlof > "$newline$nextoff"
                    Tcl_Obj* nlof    = Tcl_NewObj();
                    Tcl_AppendObjToObj(nlof, elements[1]);
                    Tcl_AppendObjToObj(nlof, nextoff);

                    // [$nlof
                    Tcl_Obj* bracketnlof = Tcl_NewObj();
                    Tcl_AppendObjToObj(bracketnlof, Tcl_NewStringObj("[", 1));
                    Tcl_AppendObjToObj(bracketnlof, nlof);

                    // $newline$begin]
                    Tcl_Obj* newlinebeginbracket = Tcl_NewObj();
                    Tcl_AppendObjToObj(newlinebeginbracket, elements[1]);
                    Tcl_AppendObjToObj(newlinebeginbracket, elements[2]);
                    Tcl_AppendObjToObj(newlinebeginbracket, Tcl_NewStringObj("]", 1));

                    Tcl_Obj *joinList = huddleJoinListC(interp, innerObj, nlof);
                    if (joinList == NULL) return NULL;

                    Tcl_Obj* newlist = Tcl_NewObj();
                    Tcl_AppendObjToObj(newlist, bracketnlof);
                    Tcl_AppendObjToObj(newlist, joinList);
                    Tcl_AppendObjToObj(newlist, newlinebeginbracket);

                    return newlist;

                } else if (!strcmp(type, "D")) {
                    // dict
                    Tcl_Obj *dictObj = huddleDictKeysC(interp, huddle_object);
                    if (dictObj == NULL) return NULL;

                    Tcl_DictSearch search;
                    Tcl_Obj *key, *value;

                    if (Tcl_DictObjFirst(interp, dictObj, &search, &key, &value, &done) != TCL_OK) {
                        Tcl_SetObjResult(
                            interp,
                            Tcl_ObjPrintf("error(huddleJsonDumpC): %s", 
                            Tcl_GetString(Tcl_GetObjResult(interp)))
                        );
                        return NULL;
                    }

                    Tcl_Obj *formatObj = Tcl_NewListObj (0,NULL);
                    Tcl_Obj *innerObj  = Tcl_NewListObj (0,NULL);

                    // offset newline nextoff
                    Tcl_ListObjAppendElement(interp, formatObj, elements[0]);
                    Tcl_ListObjAppendElement(interp, formatObj, elements[1]);
                    Tcl_ListObjAppendElement(interp, formatObj, nextoff);

                    Tcl_Obj* qm    = Tcl_NewStringObj("\"", 1);
                    Tcl_Obj* c     = Tcl_NewStringObj(":", 1);
                    Tcl_Obj* spObj = Tcl_NewStringObj(sp, strlen(sp));

                    for (; !done ; Tcl_DictObjNext(&search, &key, &value, &done)) {

                        Tcl_Obj* keylistObj = Tcl_NewObj();

                        subobject = huddleGetC(interp, huddle_object, key);
                        if (subobject == NULL) return NULL;
                        // recursive JsonDump
                        dataobj = huddleJsonDumpC(interp, subobject, formatObj);
                        if (dataobj == NULL) return NULL;

                        Tcl_AppendObjToObj(keylistObj, qm);
                        Tcl_AppendObjToObj(keylistObj, Tcl_NewStringObj(Tcl_GetString(key), -1));
                        Tcl_AppendObjToObj(keylistObj, qm);
                        Tcl_AppendObjToObj(keylistObj, c);
                        Tcl_AppendObjToObj(keylistObj, spObj);
                        Tcl_AppendObjToObj(keylistObj, dataobj);
                        Tcl_ListObjAppendElement(interp, innerObj, keylistObj);
                    }

                    Tcl_DictObjDone(&search);

                    if (Tcl_ListObjLength(interp, innerObj, &llen) != TCL_OK) {
                        Tcl_SetObjResult(
                            interp,
                            Tcl_ObjPrintf("error(huddleJsonDumpC): %s", 
                            Tcl_GetString(Tcl_GetObjResult(interp)))
                        );
                        return NULL;
                    }

                    if (llen == 1) {return innerObj;}

                    // nlof
                    Tcl_Obj* nlof = Tcl_NewObj();
                    Tcl_AppendObjToObj(nlof, elements[1]);
                    Tcl_AppendObjToObj(nlof, nextoff);

                    // {$nlof
                    Tcl_Obj* curlyBnlof = Tcl_NewObj();
                    Tcl_AppendObjToObj(curlyBnlof, Tcl_NewStringObj("{", 1));
                    Tcl_AppendObjToObj(curlyBnlof, nlof);

                    // $newline$begin}
                    Tcl_Obj* newlinebegincurlyB = Tcl_NewObj();
                    Tcl_AppendObjToObj(newlinebegincurlyB, elements[1]);
                    Tcl_AppendObjToObj(newlinebegincurlyB, elements[2]);
                    Tcl_AppendObjToObj(newlinebegincurlyB, Tcl_NewStringObj("}", 1));

                    Tcl_Obj *joinList= huddleJoinListC(interp, innerObj, nlof);
                    if (joinList == NULL) return NULL;

                    Tcl_Obj* newlist = Tcl_NewObj();
                    Tcl_AppendObjToObj(newlist, curlyBnlof);
                    Tcl_AppendObjToObj(newlist, joinList);
                    Tcl_AppendObjToObj(newlist, newlinebegincurlyB);

                    return newlist;

                } else if (!strcmp(type, "jsf")) {

                    if (Tcl_ListObjLength(interp, huddle_object, &llen) != TCL_OK) {
                        Tcl_SetObjResult(
                            interp,
                            Tcl_ObjPrintf("error(huddleJsonDumpC): %s", 
                            Tcl_GetString(Tcl_GetObjResult(interp)))
                        );
                        return NULL;
                    }
                    if (llen == 0) {
                        Tcl_SetObjResult(
                            interp, 
                            Tcl_ObjPrintf("error(huddleJsonDumpC):\
                            'jsfunc' type list is empty.")
                        );
                        return NULL;
                    }

                    Tcl_Obj* index_obj       = NULL;
                    Tcl_Obj* index_subobj    = NULL;
                    Tcl_Obj* index_subsubobj = NULL;
                    Tcl_ListObjIndex(interp, huddle_object, 1, &index_obj);
                    Tcl_ListObjIndex(interp, index_obj,     1, &index_subobj);
                    Tcl_ListObjIndex(interp, index_subobj,  0, &index_subsubobj);

                    return index_subsubobj;

                } else if (!strcmp(type, "LPN")) {

                    Tcl_Obj* node = huddleUnwrapC(interp, huddle_object);
                    if (node == NULL) return NULL;

                    Tcl_Obj* index_obj;
                    Tcl_Obj **sub_elements;
                    Tcl_Obj *joinList = NULL;
                    Tcl_Obj* nlist = Tcl_NewObj();

                    Tcl_ListObjIndex(interp, node, 1, &index_obj);
                    
                    if (Tcl_ListObjGetElements(interp, index_obj, &count, &sub_elements) != TCL_OK) {
                        Tcl_SetObjResult(
                            interp,
                            Tcl_ObjPrintf("error(huddleJsonDumpC): %s", 
                            Tcl_GetString(Tcl_GetObjResult(interp)))
                        );
                        return NULL;
                    }

                    if (count == 0) {
                        Tcl_SetObjResult(
                            interp, 
                            Tcl_ObjPrintf("error(huddleJsonDumpC):\
                            'lpn' type list is empty.")
                        );
                        return NULL;
                    }

                    // nlof > "$newline$nextoff"
                    Tcl_Obj* nlof    = Tcl_NewObj();
                    Tcl_AppendObjToObj(nlof, elements[1]);
                    Tcl_AppendObjToObj(nlof, nextoff);

                    // [$nlof
                    Tcl_Obj* bracketnlof = Tcl_NewObj();
                    Tcl_AppendObjToObj(bracketnlof, Tcl_NewStringObj("[", 1));
                    Tcl_AppendObjToObj(bracketnlof, nlof);

                    // $newline$begin]
                    Tcl_Obj* newlinebeginbracket = Tcl_NewObj();
                    Tcl_AppendObjToObj(newlinebeginbracket, elements[1]);
                    Tcl_AppendObjToObj(newlinebeginbracket, elements[2]);
                    Tcl_AppendObjToObj(newlinebeginbracket, Tcl_NewStringObj("]", 1));

                    if (count == 1) {
                        Tcl_Obj* index_subsubobj = NULL;
                        Tcl_ListObjIndex(interp, index_obj, 0, &index_subsubobj);

                        joinList = huddleJoinListC(interp, index_subsubobj, nlof);
                        if (joinList == NULL) return NULL;

                        Tcl_AppendObjToObj(nlist, bracketnlof);
                        Tcl_AppendObjToObj(nlist, joinList);
                        Tcl_AppendObjToObj(nlist, newlinebeginbracket);

                        return nlist;
                    } else {
                        Tcl_Obj* data = Tcl_NewObj();
                        for (i = 0; i < count; ++i) {
                            joinList = huddleJoinListC(interp, sub_elements[i], nlof);
                            if (joinList == NULL) return NULL;
                            Tcl_Obj* newlist = Tcl_NewObj();
                            Tcl_AppendObjToObj(newlist, bracketnlof);
                            Tcl_AppendObjToObj(newlist, joinList);
                            Tcl_AppendObjToObj(newlist, newlinebeginbracket);
                            Tcl_ListObjAppendElement(interp, data, newlist);
                        }

                        joinList = huddleJoinListC(interp, data, nlof);
                        if (joinList == NULL) return NULL;
                        Tcl_AppendObjToObj(nlist, bracketnlof);
                        Tcl_AppendObjToObj(nlist, joinList);
                        Tcl_AppendObjToObj(nlist, newlinebeginbracket);

                        return nlist;
                    }

                } else {
                    Tcl_SetObjResult(
                        interp,
                        Tcl_ObjPrintf("error(huddleJsonDumpC): type not supported '%s'", 
                        type)
                    );
                    return NULL;
                }
            }
        }
    }
]; {*}$critCmd

critcl::cproc critHuddleDump {Tcl_Interp* interp Tcl_Obj* huddle Tcl_Obj* format} ok {
    /*
     * Tcl_Interp* interp  - The Tcl interpreter object.
     * Tcl_Obj* huddle     - the huddle object to dump.
     * Tcl_Obj* format     - the format options.
     *
     * Returns TCL_OK or TCL_ERROR.
     *
     * The purpose of this function is to dump a huddle object to a JSON
     * string.
     */
    Tcl_Obj* json;

    json = huddleJsonDumpC(interp, huddle, format);

    if (json == NULL) return TCL_ERROR;

    // Set the result of the command to the JSON string.
    Tcl_SetObjResult(interp, json);

    return TCL_OK;
}


critcl::cproc critIsHuddle {Tcl_Interp* interp Tcl_Obj* huddle} ok {
    /*
     * Tcl_Interp* interp  - The Tcl interpreter object.
     * Tcl_Obj* huddle     - the huddle object to check.
     *
     * Returns TCL_OK or TCL_ERROR.
     *
     * The purpose of this function is to check if a object is a huddle
     * object.
     */
    int result = isHuddleC(interp, huddle);

    if (result == -1) return TCL_ERROR;

    // Set the result of the command to the boolean value.
    Tcl_SetObjResult(interp, Tcl_NewBooleanObj(result));

    return TCL_OK;
}

critcl::cproc critRetrieveHuddle {Tcl_Interp* interp Tcl_Obj* huddle_object Tcl_Obj* path int stripped} ok {
    /*
     * Tcl_Interp* interp      - The Tcl interpreter object.
     * Tcl_Obj* huddle_object  - The huddle object to retrieve data from.
     * Tcl_Obj* path           - The path within the huddle object to retrieve.
     * int stripped            - A flag indicating whether the result should be stripped.
     *
     * Returns TCL_OK or TCL_ERROR.
     *
     * The purpose of this function is to retrieve data from a specific path
     * within a huddle object.
     * From huddle package.
     */
    Tcl_Obj* result = huddleRetrieveHuddleC(interp, huddle_object, path, stripped);

    if (result == NULL) return TCL_ERROR;

    // Set the result of the command to the retrieved object.
    Tcl_SetObjResult(interp, result);

    return TCL_OK;
}

critcl::cproc critHuddleListMap {Tcl_Interp* interp Tcl_Obj* data} ok {
    /*
     * Tcl_Interp* interp  - The Tcl interpreter object.
     * Tcl_Obj* data       - The list of lists to map.
     *
     * Returns TCL_OK or TCL_ERROR.
     *
     * The purpose of this function is to insert data into a huddle list.
     * From ehuddle.tcl
     */

    Tcl_Obj **elements, **sub_elements, **sub_list;
    Tcl_Size count, subcount, length, i, j;
    const char *str;
    double d;

    if (Tcl_ListObjGetElements(interp, data, &count, &elements) != TCL_OK) {
        return TCL_ERROR;
    }

    if (Tcl_ListObjGetElements(interp, elements[0], &count, &sub_elements) != TCL_OK) {
        return TCL_ERROR;
    }

    Tcl_Obj *dataObj = Tcl_NewListObj (0,NULL);
    Tcl_Obj* s       = Tcl_NewStringObj("s", 1);
    Tcl_Obj* D       = Tcl_NewStringObj("D", 1);
    Tcl_Obj* L       = Tcl_NewStringObj("L", 1);
    Tcl_Obj* n       = Tcl_NewStringObj("num", 3);
    Tcl_Obj* null    = Tcl_NewStringObj("null", 4);
    Tcl_Obj* type;

    for (i = 0; i < count; ++i) {
        Tcl_Obj *innerObj = Tcl_NewListObj (0,NULL);
        Tcl_Obj* lTag     = Tcl_NewObj();

        Tcl_ListObjGetElements(interp, sub_elements[i], &subcount, &sub_list);

        for (j = 0; j < subcount; j++) {
            Tcl_Obj* dataTag = Tcl_NewObj();

            if (Tcl_GetDoubleFromObj(NULL, sub_list[j], &d) == TCL_OK) {
                type = n;
            } else {
                str = Tcl_GetString(sub_list[j]);

                if (!strcmp(str, "null")) {
                    type = null;
                } else if (!strncmp(str, "::oo::Obj", 9)) {
                    type = s;
                    int typeObj = getObjFromClass(interp, sub_list[j]);
                    if (typeObj < 0) return TCL_ERROR;

                    sub_list[j] = Tcl_GetObjResult(interp);

                    // typeObj = 1 : eString class
                    // typeObj = 2 : eStruct class
                    if (typeObj == 2) {
                        if (Tcl_ListObjLength(interp, sub_list[j], &length) != TCL_OK) {
                            return TCL_ERROR;
                        }
                        if (length == 0) {
                            Tcl_SetObjResult(
                                interp,
                                Tcl_ObjPrintf("error(critHuddleListMap):\
                                'huddle' list is empty.")
                            );
                            return TCL_ERROR;
                        }
                        Tcl_Obj* index_obj = NULL;
                        Tcl_ListObjIndex(interp, sub_list[j], 0, &index_obj);
                        str = Tcl_GetString(index_obj);

                        if (!strncmp(str, "D", 1)) {
                            type = D;
                        } else if (!strncmp(str, "L", 1)) {
                            type = L;
                        }

                        Tcl_ListObjIndex(interp, sub_list[j], 1, &index_obj);
                        sub_list[j] = index_obj;
                    }
                } else {
                    type = s;
                }
            }

            Tcl_ListObjAppendElement(interp, dataTag, type);
            Tcl_ListObjAppendElement(interp, dataTag, sub_list[j]);

            Tcl_ListObjAppendElement(interp, innerObj, dataTag);
        }

        Tcl_ListObjAppendElement(interp, lTag, L);
        Tcl_ListObjAppendElement(interp, lTag, innerObj);
        Tcl_ListObjAppendElement(interp, dataObj, lTag);
    }

    Tcl_SetObjResult(interp, dataObj);

    return TCL_OK;
}

critcl::cproc critHuddleListInsert {Tcl_Interp* interp Tcl_Obj* data} ok {
    /*
     * Tcl_Interp* interp  - The Tcl interpreter object.
     * Tcl_Obj* data       - The list of lists to insert.
     *
     * Returns TCL_OK or TCL_ERROR.
     *
     * The purpose of this function is to insert data into a huddle list.
     * From ehuddle.tcl
     */

    Tcl_Obj **elements, **sub_elements, **sub_list;
    Tcl_Size count, length, i;
    const char *str;
    double d;

    if (Tcl_ListObjGetElements(interp, data, &count, &elements) != TCL_OK) {
        return TCL_ERROR;
    }

    if (Tcl_ListObjGetElements(interp, elements[0], &count, &sub_list) != TCL_OK) {
        return TCL_ERROR;
    }

    if (Tcl_ListObjGetElements(interp, sub_list[0], &count, &sub_elements) != TCL_OK) {
        return TCL_ERROR;
    }

    Tcl_Obj *dataObj = Tcl_NewListObj (0,NULL);
    Tcl_Obj* s       = Tcl_NewStringObj("s", 1);
    Tcl_Obj* D       = Tcl_NewStringObj("D", 1);
    Tcl_Obj* L       = Tcl_NewStringObj("L", 1);
    Tcl_Obj* n       = Tcl_NewStringObj("num", 3);
    Tcl_Obj* null    = Tcl_NewStringObj("null", 4);
    Tcl_Obj* type;

    for (i = 0; i < count; ++i) {
        Tcl_Obj* dataTag = Tcl_NewObj();

        if (Tcl_GetDoubleFromObj(NULL, sub_elements[i], &d) == TCL_OK) {
            type = n;
        } else {
            str = Tcl_GetString(sub_elements[i]);

            if (!strcmp(str, "null")) {
                type = null;
            } else if (!strncmp(str, "::oo::Obj", 9)) {
                type = s;
                int typeObj = getObjFromClass(interp, sub_elements[i]);
                if (typeObj < 0) return TCL_ERROR;

                sub_elements[i] = Tcl_GetObjResult(interp);

                // typeObj == 1 : eString class
                // typeObj == 2 : eStruct class
                if (typeObj == 2) {
                    if (Tcl_ListObjLength(interp, sub_elements[i], &length) != TCL_OK) {
                        return TCL_ERROR;
                    }
                    if (length == 0) {
                        Tcl_SetObjResult(
                            interp,
                            Tcl_ObjPrintf("error(critHuddleListInsert):\
                            'huddle' list is empty.")
                        );
                        return TCL_ERROR;
                    }
                    Tcl_Obj* index_obj = NULL;
                    Tcl_ListObjIndex(interp, sub_elements[i], 0, &index_obj);
                    str = Tcl_GetString(index_obj);

                    if (!strncmp(str, "D", 1)) {
                        type = D;
                    } else if (!strncmp(str, "L", 1)) {
                        type = L;
                    }

                    Tcl_ListObjIndex(interp, sub_elements[i], 1, &index_obj);
                    sub_elements[i] = index_obj;
                }
            } else {
                type = s;
            }
        }

        Tcl_ListObjAppendElement(interp, dataTag, type);
        Tcl_ListObjAppendElement(interp, dataTag, sub_elements[i]);

        Tcl_ListObjAppendElement(interp, dataObj, dataTag);
    }

    Tcl_SetObjResult(interp, dataObj);

    return TCL_OK;
}

critcl::cproc critHuddleTypeList {Tcl_Interp* interp Tcl_Obj* data} ok {
    /*
     * Tcl_Interp* interp  - The Tcl interpreter object.
     * Tcl_Obj* data       - The list of lists to insert.
     *
     * Returns TCL_OK or TCL_ERROR.
     *
     * The purpose of this function is to insert data into a huddle list.
     * From huddle package.
     */

    Tcl_Obj **elements;
    Tcl_Size count, i;

    if (Tcl_ListObjGetElements(interp, data, &count, &elements) != TCL_OK) {
        return TCL_ERROR;
    }

    Tcl_Obj *dataObj = Tcl_NewListObj(0,NULL);

    for (i = 0; i < count; ++i) {
        Tcl_Obj* hwc = huddleArgToNodeC(interp, elements[i]);
        if (hwc == NULL) return TCL_ERROR;
        Tcl_ListObjAppendElement(interp, dataObj, hwc);
    }

    Tcl_Obj* listTag = Tcl_NewObj();
    Tcl_Obj* L       = Tcl_NewStringObj("L", 1);

    Tcl_ListObjAppendElement(interp, listTag, L);
    Tcl_ListObjAppendElement(interp, listTag, dataObj);

    Tcl_Obj* wrap = huddleWrapC(interp, listTag);

    Tcl_SetObjResult(interp, wrap);

    return TCL_OK;
}

critcl::load ; # force compilation...