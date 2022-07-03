#include <mruby.h>
#include <string.h>
#include <assert.h>
#include <mruby/string.h>
#include <mruby/data.h>
#include <dragonruby.h>
#include "ext/verlet.h"

static drb_api_t *drb_api;

static void drb_free_foreign_object_indirect(mrb_state *state, void *pointer) {
    drb_api->drb_free_foreign_object(state, pointer);
}
static int drb_ffi__ZTSi_FromRuby(mrb_state *state, mrb_value self) {
    drb_api->drb_typecheck_int(state, self);
    return mrb_fixnum(self);
}
static mrb_value drb_ffi__ZTSi_ToRuby(mrb_state *state, int value) {
    return mrb_fixnum_value(value);
}
static char drb_ffi__ZTSc_FromRuby(mrb_state *state, mrb_value self) {
    drb_api->drb_typecheck_int(state, self);
    return mrb_fixnum(self);
}
static mrb_value drb_ffi__ZTSc_ToRuby(mrb_state *state, char value) {
    return mrb_fixnum_value(value);
}
struct drb_foreign_object_ZTS3VSR {
    drb_foreign_object_kind kind;
    Verlet_SolveResult value;
};
static mrb_data_type ForeignObjectType_ZTS3VSR = {"VSR", drb_free_foreign_object_indirect};
static Verlet_SolveResult drb_ffi__ZTS3VSR_FromRuby(mrb_state *state, mrb_value self) {
    struct RClass *FFI = drb_api->mrb_module_get(state, "FFI");
    struct RClass *module = drb_api->mrb_module_get_under(state, FFI, "CExt");
    struct RClass *klass = drb_api->mrb_class_get_under(state, module, "VSR");
    drb_api->drb_typecheck_aggregate(state, self, klass, &ForeignObjectType_ZTS3VSR);
    return ((struct drb_foreign_object_ZTS3VSR *)DATA_PTR(self))->value;
}
static mrb_value drb_ffi__ZTS3VSR_ToRuby(mrb_state *state, Verlet_SolveResult value) {
    struct drb_foreign_object_ZTS3VSR *ptr = calloc(1, sizeof(struct drb_foreign_object_ZTS3VSR));
    ptr->value = value;
    ptr->kind = drb_foreign_object_kind_struct;
    struct RClass *FFI = drb_api->mrb_module_get(state, "FFI");
    struct RClass *module = drb_api->mrb_module_get_under(state, FFI, "CExt");
    struct RClass *klass = drb_api->mrb_class_get_under(state, module, "VSR");
    struct RData *rdata = drb_api->mrb_data_object_alloc(state, klass, ptr, &ForeignObjectType_ZTS3VSR);
    return mrb_obj_value(rdata);
}
static double drb_ffi__ZTSd_FromRuby(mrb_state *state, mrb_value self) {
    drb_api->drb_typecheck_float(state, self);
    return mrb_float(self);
}
static mrb_value drb_ffi__ZTSd_ToRuby(mrb_state *state, double value) {
    return drb_api->drb_float_value(state, value);
}
static mrb_value drb_ffi__ZTS3VSR_New(mrb_state *state, mrb_value self) {
    struct drb_foreign_object_ZTS3VSR *ptr = calloc(1, sizeof(struct drb_foreign_object_ZTS3VSR *));
    struct RClass *FFI = drb_api->mrb_module_get(state, "FFI");
    struct RClass *module = drb_api->mrb_module_get_under(state, FFI, "CExt");
    struct RClass *klass = drb_api->mrb_class_get_under(state, module, "VSR");
    struct RData *rdata = drb_api->mrb_data_object_alloc(state, klass, ptr, &ForeignObjectType_ZTS3VSR);
    return mrb_obj_value(rdata);
}
static mrb_value drb_ffi__ZTS3VSR_p1x_Get(mrb_state *state, mrb_value self) {
    Verlet_SolveResult record = drb_ffi__ZTS3VSR_FromRuby(state, self);
    return drb_ffi__ZTSd_ToRuby(state, record.p1x);
}
static mrb_value drb_ffi__ZTS3VSR_p1x_Set(mrb_state *state, mrb_value self) {
    mrb_value *args = 0;
    mrb_int argc = 0;
    drb_api->mrb_get_args(state, "*", &args, &argc);
    double new_value = drb_ffi__ZTSd_FromRuby(state, args[0]);
    (&((struct drb_foreign_object_ZTS3VSR *)DATA_PTR(self))->value)->p1x = new_value;
    return mrb_nil_value();
}
static mrb_value drb_ffi__ZTS3VSR_p1y_Get(mrb_state *state, mrb_value self) {
    Verlet_SolveResult record = drb_ffi__ZTS3VSR_FromRuby(state, self);
    return drb_ffi__ZTSd_ToRuby(state, record.p1y);
}
static mrb_value drb_ffi__ZTS3VSR_p1y_Set(mrb_state *state, mrb_value self) {
    mrb_value *args = 0;
    mrb_int argc = 0;
    drb_api->mrb_get_args(state, "*", &args, &argc);
    double new_value = drb_ffi__ZTSd_FromRuby(state, args[0]);
    (&((struct drb_foreign_object_ZTS3VSR *)DATA_PTR(self))->value)->p1y = new_value;
    return mrb_nil_value();
}
static mrb_value drb_ffi__ZTS3VSR_p2x_Get(mrb_state *state, mrb_value self) {
    Verlet_SolveResult record = drb_ffi__ZTS3VSR_FromRuby(state, self);
    return drb_ffi__ZTSd_ToRuby(state, record.p2x);
}
static mrb_value drb_ffi__ZTS3VSR_p2x_Set(mrb_state *state, mrb_value self) {
    mrb_value *args = 0;
    mrb_int argc = 0;
    drb_api->mrb_get_args(state, "*", &args, &argc);
    double new_value = drb_ffi__ZTSd_FromRuby(state, args[0]);
    (&((struct drb_foreign_object_ZTS3VSR *)DATA_PTR(self))->value)->p2x = new_value;
    return mrb_nil_value();
}
static mrb_value drb_ffi__ZTS3VSR_p2y_Get(mrb_state *state, mrb_value self) {
    Verlet_SolveResult record = drb_ffi__ZTS3VSR_FromRuby(state, self);
    return drb_ffi__ZTSd_ToRuby(state, record.p2y);
}
static mrb_value drb_ffi__ZTS3VSR_p2y_Set(mrb_state *state, mrb_value self) {
    mrb_value *args = 0;
    mrb_int argc = 0;
    drb_api->mrb_get_args(state, "*", &args, &argc);
    double new_value = drb_ffi__ZTSd_FromRuby(state, args[0]);
    (&((struct drb_foreign_object_ZTS3VSR *)DATA_PTR(self))->value)->p2y = new_value;
    return mrb_nil_value();
}
static mrb_value drb_ffi__ZTS3VSR_rm_Get(mrb_state *state, mrb_value self) {
    Verlet_SolveResult record = drb_ffi__ZTS3VSR_FromRuby(state, self);
    return drb_ffi__ZTSc_ToRuby(state, record.rm);
}
static mrb_value drb_ffi__ZTS3VSR_rm_Set(mrb_state *state, mrb_value self) {
    mrb_value *args = 0;
    mrb_int argc = 0;
    drb_api->mrb_get_args(state, "*", &args, &argc);
    char new_value = drb_ffi__ZTSc_FromRuby(state, args[0]);
    (&((struct drb_foreign_object_ZTS3VSR *)DATA_PTR(self))->value)->rm = new_value;
    return mrb_nil_value();
}
static mrb_value drb_ffi_Verlet_init_Binding(mrb_state *state, mrb_value value) {
    mrb_value *args = 0;
    mrb_int argc = 0;
    drb_api->mrb_get_args(state, "*", &args, &argc);
    if (argc != 1)
        drb_api->mrb_raisef(state, drb_api->drb_getargument_error(state), "'Verlet_init': wrong number of arguments (%d for 1)", argc);
    char _0 = drb_ffi__ZTSc_FromRuby(state, args[0]);
    Verlet_init(_0);
    return mrb_nil_value();
}
static mrb_value drb_ffi_Verlet_solve_Binding(mrb_state *state, mrb_value value) {
    mrb_value *args = 0;
    mrb_int argc = 0;
    drb_api->mrb_get_args(state, "*", &args, &argc);
    if (argc != 8)
        drb_api->mrb_raisef(state, drb_api->drb_getargument_error(state), "'Verlet_solve': wrong number of arguments (%d for 8)", argc);
    double p1x_0 = drb_ffi__ZTSd_FromRuby(state, args[0]);
    double p1y_1 = drb_ffi__ZTSd_FromRuby(state, args[1]);
    double p2x_2 = drb_ffi__ZTSd_FromRuby(state, args[2]);
    double p2y_3 = drb_ffi__ZTSd_FromRuby(state, args[3]);
    double tear_sensitivity_4 = drb_ffi__ZTSd_FromRuby(state, args[4]);
    double resting_distance_5 = drb_ffi__ZTSd_FromRuby(state, args[5]);
    double scalar_p1_6 = drb_ffi__ZTSd_FromRuby(state, args[6]);
    double scalar_p2_7 = drb_ffi__ZTSd_FromRuby(state, args[7]);
    Verlet_SolveResult ret_val = Verlet_solve(p1x_0, p1y_1, p2x_2, p2y_3, tear_sensitivity_4, resting_distance_5, scalar_p1_6, scalar_p2_7);
    return drb_ffi__ZTS3VSR_ToRuby(state, ret_val);
}
DRB_FFI_EXPORT
void drb_register_c_extensions_with_api(mrb_state *state, struct drb_api_t *api) {
    drb_api = api;
    struct RClass *FFI = drb_api->mrb_module_get(state, "FFI");
    struct RClass *module = drb_api->mrb_define_module_under(state, FFI, "CExt");
    struct RClass *object_class = state->object_class;
    drb_api->mrb_define_module_function(state, module, "Verlet_init", drb_ffi_Verlet_init_Binding, MRB_ARGS_REQ(1));
    drb_api->mrb_define_module_function(state, module, "Verlet_solve", drb_ffi_Verlet_solve_Binding, MRB_ARGS_REQ(8));
    struct RClass *VSRClass = drb_api->mrb_define_class_under(state, module, "VSR", object_class);
    drb_api->mrb_define_class_method(state, VSRClass, "new", drb_ffi__ZTS3VSR_New, MRB_ARGS_REQ(0));
    drb_api->mrb_define_method(state, VSRClass, "p1x", drb_ffi__ZTS3VSR_p1x_Get, MRB_ARGS_REQ(0));
    drb_api->mrb_define_method(state, VSRClass, "p1x=", drb_ffi__ZTS3VSR_p1x_Set, MRB_ARGS_REQ(1));
    drb_api->mrb_define_method(state, VSRClass, "p1y", drb_ffi__ZTS3VSR_p1y_Get, MRB_ARGS_REQ(0));
    drb_api->mrb_define_method(state, VSRClass, "p1y=", drb_ffi__ZTS3VSR_p1y_Set, MRB_ARGS_REQ(1));
    drb_api->mrb_define_method(state, VSRClass, "p2x", drb_ffi__ZTS3VSR_p2x_Get, MRB_ARGS_REQ(0));
    drb_api->mrb_define_method(state, VSRClass, "p2x=", drb_ffi__ZTS3VSR_p2x_Set, MRB_ARGS_REQ(1));
    drb_api->mrb_define_method(state, VSRClass, "p2y", drb_ffi__ZTS3VSR_p2y_Get, MRB_ARGS_REQ(0));
    drb_api->mrb_define_method(state, VSRClass, "p2y=", drb_ffi__ZTS3VSR_p2y_Set, MRB_ARGS_REQ(1));
    drb_api->mrb_define_method(state, VSRClass, "rm", drb_ffi__ZTS3VSR_rm_Get, MRB_ARGS_REQ(0));
    drb_api->mrb_define_method(state, VSRClass, "rm=", drb_ffi__ZTS3VSR_rm_Set, MRB_ARGS_REQ(1));
}
