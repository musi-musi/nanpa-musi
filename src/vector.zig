const std = @import("std");
const asserts = @import("asserts.zig");
const axis = @import("axis.zig");

pub fn Vector(comptime Scalar_: type, comptime dimensions_: comptime_int) type {
    comptime asserts.assertFloatOrInt(Scalar_);
    comptime asserts.assertValidDimensionCount(dimensions_);
    return extern struct {
        
        v: Value,

        pub const Value = [dimensions]Scalar;
        pub const Scalar = Scalar_;
        pub const dimensions = dimensions_;

        pub const Axis = axis.Axis(dimensions);

        pub const axes = Axis.values;
        pub const indices = ([4]u32{0, 1, 2, 3})[0..dimensions];

        const Self = @This();

        pub fn init(v: Value) Self {
            return .{ .v = v};
        }

        pub fn get(self: Self, comptime a: Axis) Scalar {
            return self.v[@enumToInt(a)];
        }
        pub fn set(self: *Self, comptime a: Axis, v: Scalar) void {
            self.v[@enumToInt(a)] = v;
        }
        pub fn ptr(self: *const Self, comptime a: Axis) *const Scalar {
            return &(self.v[@enumToInt(a)]);
        }
        pub fn ptrMut(self: *Self, comptime a: Axis) *Scalar {
            return &(self.v[@enumToInt(a)]);
        }

        pub fn fill(v: Scalar) Self {
            var res: Self = undefined;
            inline for(indices) |i| {
                res.v[i] = v;
            }
            return res;
        }

        pub fn unit(comptime a: Axis) Self {
            comptime {
                var res = fill(0);
                res.set(a, 1);
                return res;
            }
        }

        /// unary negation
        pub fn neg(self: Self) Self {
            var res: Self = undefined;
            inline for (indices) |i| {
                res.v[i] = -self.v[i];
            }
            return res;
        }

        /// component-wise addition
        pub fn add(a: Self, b: Self) Self {
            var res: Self = undefined;
            inline for (indices) |i| {
                res.v[i] = a.v[i] + b.v[i];
            }
            return res;
        }

        /// component-wise subtraction
        pub fn sub(a: Self, b: Self) Self {
            var res: Self = undefined;
            inline for (indices) |i| {
                res.v[i] = a.v[i] - b.v[i];
            }
            return res;
        }

        /// component-wise multiplication
        pub fn mul(a: Self, b: Self) Self {
            var res: Self = undefined;
            inline for (indices) |i| {
                res.v[i] = a.v[i] * b.v[i];
            }
            return res;
        }

        /// component-wise division
        pub fn div(a: Self, b: Self) Self {
            var res: Self = undefined;
            inline for (indices) |i| {
                res.v[i] = a.v[i] / b.v[i];
            }
            return res;
        }

        /// scalar multiplication
        pub fn mulScalar(a: Self, b: Scalar) Self {
            var res: Self = undefined;
            inline for (indices) |i| {
                res.v[i] = a.v[i] * b;
            }
            return res;
        }

        /// scalar division
        pub fn divScalar(a: Self, b: Scalar) Self {
            var res: Self = undefined;
            inline for (indices) |i| {
                res.v[i] = a.v[i] / b;
            }
            return res;
        }

        /// sum of components
        pub fn sum(self: Self) Self {
            var res: Scalar = 0;
            inline for (indices) |i| {
                res += self.v[i];
            }
            return res;
        }

        /// product of components
        pub fn product(self: Self) Self {
            var res: Scalar = 0;
            inline for (indices) |i| {
                res *= self.v[i];
            }
            return res;
        }

        /// dot product
        pub fn dot(a: Self, b: Self) Scalar {
            return a.mul(b).sum();
        }

        /// square magnitude
        pub fn mag2(self: Self) Scalar {
            return self.dot(self);
        }

        /// magnitude
        pub fn mag(self: Self) Scalar {
            return std.math.sqrt(self.mag2());
        }

    };
}

pub const Vec2 = Vector(f32, 2);
pub const Vec3 = Vector(f32, 3);
pub const Vec4 = Vector(f32, 4);

pub fn vec2(v: Vec2.Value) Vec2 {
    return Vec2.init(v);
}
pub fn vec3(v: Vec3.Value) Vec3 {
    return Vec3.init(v);
}
pub fn vec4(v: Vec4.Value) Vec4 {
    return Vec4.init(v);
}

pub const Vec2d = Vector(f64, 2);
pub const Vec3d = Vector(f64, 3);
pub const Vec4d = Vector(f64, 4);

pub fn vec2d(v: Vec2d.Value) Vec2d {
    return Vec2d.init(v);
}
pub fn vec3d(v: Vec3d.Value) Vec3d {
    return Vec3d.init(v);
}
pub fn vec4d(v: Vec4d.Value) Vec4d {
    return Vec4d.init(v);
}

pub const Vec2i = Vector(i32, 2);
pub const Vec3i = Vector(i32, 3);
pub const Vec4i = Vector(i32, 4);

pub fn vec2i(v: Vec2i.Value) Vec2i {
    return Vec2i.init(v);
}
pub fn vec3i(v: Vec3i.Value) Vec3i {
    return Vec3i.init(v);
}
pub fn vec4i(v: Vec4i.Value) Vec4i {
    return Vec4i.init(v);
}

pub const Vec2u = Vector(u32, 2);
pub const Vec3u = Vector(u32, 3);
pub const Vec4u = Vector(u32, 4);

pub fn vec2u(v: Vec2u.Value) Vec2u {
    return Vec2u.init(v);
}
pub fn vec3u(v: Vec3u.Value) Vec3u {
    return Vec3u.init(v);
}
pub fn vec4u(v: Vec4u.Value) Vec4u {
    return Vec4u.init(v);
}