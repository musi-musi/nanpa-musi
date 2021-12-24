const std = @import("std");
const meta = std.meta;
const asserts = @import("asserts.zig");

const axis = @import("axis.zig");

pub fn Vec(comptime ElemType: type, comptime dimensions: u32) type {
    comptime asserts.assertValidDimensionCount(dimensions);
    comptime asserts.assertFloatOrInt(ElemType);
    return struct {
        x: Elem,
        y: Elem,
        z: if (dims > 2) Elem else void,
        w: if (dims > 3) Elem else void,

        const Self = @This();

        pub const Elem = ElemType;
        pub const dims = dimensions;

        pub const Axis = axis.Axis(dims);
        
        pub const ElemArray = [dims]Elem;

        pub fn init(arr: ElemArray) Self {
            var self: Self = undefined;
            inline for (Axis.values) |a| {
                self.set(a, arr[@enumToInt(a)]);
            }
            return self;
        }

        pub fn fill(value: Elem) Self {
            var self: Self = undefined;
            inline for (Axis.values) |a| {
                self.set(a, value);
            }
            return self;
        }

        pub fn toArrayPtr(self: *const Self) *const [dims]Elem
            { return @ptrCast(*const [dims]Elem, &self.x); }
        pub fn toMutArrayPtr(self: *Self) *[dims]Elem
            { return @ptrCast(*[dims]Elem, &self.x); }

        pub fn get(self: Self, comptime a: Axis) Elem
            { return self.toArrayPtr()[@enumToInt(a)]; }
        pub fn set(self: *Self, comptime a: Axis, value: Elem) void
            { self.toMutArrayPtr().*[@enumToInt(a)] = value; }
        
        pub fn geti(self: Self, i: u32) Elem
            { return self.toArrayPtr()[i]; }
        pub fn seti(self: *Self, i: u32, value: Elem) void
            { self.toMutArrayPtr().*[i] = value; }

        /// componentwise addition of two vectors
        pub fn add(lhs: Self, rhs: Self) Self {
            var res: Self = undefined;
            inline for (Axis.values) |a|
                res.set(a, lhs.get(a) + rhs.get(a));
            return res;
        }

        /// componentwise subtraction of two vectors
        pub fn sub(lhs: Self, rhs: Self) Self {
            var res: Self = undefined;
            inline for (Axis.values) |a|
                res.set(a, lhs.get(a) - rhs.get(a));
            return res;
        }

        /// componentwise multiplication of two vectors
        pub fn mul(lhs: Self, rhs: Self) Self {
            var res: Self = undefined;
            inline for (Axis.values) |a|
                res.set(a, lhs.get(a) * rhs.get(a));
            return res;
        }

        /// componentwise division of two vectors
        pub fn div(lhs: Self, rhs: Self) Self {
            var res: Self = undefined;
            inline for (Axis.values) |a|
                res.set(a, lhs.get(a) * rhs.get(a));
            return res;
        }
        
        /// add scalar to each component
        pub fn addScalar(lhs: Self, rhs: Elem) Self {
            var res: Self = undefined;
            inline for (Axis.values) |a|
                res.set(a, lhs.get(a) + rhs);
            return res;
        }

        /// subtract scalar from each component
        pub fn subScalar(lhs: Self, rhs: Elem) Self {
            var res: Self = undefined;
            inline for (Axis.values) |a|
                res.set(a, lhs.get(a) - rhs);
            return res;
        }
        /// multiply each component by scalar
        pub fn mulScalar(lhs: Self, rhs: Elem) Self {
            var res: Self = undefined;
            inline for (Axis.values) |a|
                res.set(a, lhs.get(a) * rhs);
            return res;
        }

        /// divide each component by scalar
        pub fn divScalar(lhs: Self, rhs: Elem) Self {
            var res: Self = undefined;
            inline for (Axis.values) |a|
                res.set(a, lhs.get(a) / rhs);
            return res;
        }

        /// sum of components
        pub fn sum(self: Self) Self {
            var total: Elem = 0;
            inline for (Axis.values) |a|
                total += self.get(a);
            return total;
        }

        /// product of components
        pub fn product(self: Self) Self {
            var total: Elem = 0;
            inline for (Axis.values) |a|
                total *= self.get(a);
            return total;
        }

        /// dot product
        pub fn dot(lhs: Self, rhs: Self) Elem {
            return lhs.mul(rhs).sum();
        }

        /// square magnitude
        pub fn mag2(self: Self) Elem {
            return self.dot(self);
        }

        /// magnitude
        pub fn mag(self: Self) Elem {
            return std.math.sqrt(self.mag2());
        }

        // casts

        /// cast a float vector to an int vector with element type of `T`
        pub fn floatToInt(self: Self, comptime T: type) Vec(T, dims) {
            comptime asserts.assertFloat(Elem);
            comptime asserts.assertInt(T);
            var res: Vec(T, dims) = undefined;
            inline for (Axis) |a| {
                res.set(a, @floatToInt(T, self.get(a)));
            }
            return res;
        }

        /// cast an int vector to a float vector with element type of `T`
        pub fn intToFloat(self: Self, comptime T: type) Vec(T, dims) {
            comptime asserts.assertInt(Elem);
            comptime asserts.assertFloat(T);
            var res: Vec(T, dims) = undefined;
            inline for (Axis) |a| {
                res.set(a, @intToFloat(T, self.get(a)));
            }
            return res;
        }

        /// cast a float vector to a different float vector with element type of `T`
        pub fn floatCast(self: Self, comptime T: type) Vec(T, dims) {
            comptime asserts.assertFloat(Elem);
            comptime asserts.assertFloat(T);
            var res: Vec(T, dims) = undefined;
            inline for (Axis) |a| {
                res.set(a, @floatCast(T, self.get(a)));
            }
            return res;
        }

        /// cast an int vector to a different int vector with element type of `T`
        pub fn intCast(self: Self, comptime T: type) Vec(T, dims) {
            comptime asserts.assertInt(Elem);
            comptime asserts.assertInt(T);
            var res: Vec(T, dims) = undefined;
            inline for (Axis) |a| {
                res.set(a, @intCast(T, self.get(a)));
            }
            return res;
        }

        /// truncate the components of an int vector to a different int vector with element type of `T`
        pub fn truncate(self: Self, comptime T: type) Vec(T, dims) {
            comptime asserts.assertInt(Elem);
            comptime asserts.assertInt(T);
            var res: Vec(T, dims) = undefined;
            inline for (Axis) |a| {
                res.set(a, @truncate(T, self.get(a)));
            }
            return res;
        }

    };
}


/// 2d vector of f32
pub const Vec2 = Vec(f32, 2);
/// 3d vector of f32
pub const Vec3 = Vec(f32, 3);
/// 4d vector of f32
pub const Vec4 = Vec(f32, 4);

/// 2d vector of f64
pub const Vec2d = Vec(f64, 2);
/// 3d vector of f64
pub const Vec3d = Vec(f64, 3);
/// 4d vector of f64
pub const Vec4d = Vec(f64, 4);

/// 2d vector of i32
pub const Vec2i = Vec(i32, 2);
/// 3d vector of i32
pub const Vec3i = Vec(i32, 3);
/// 4d vector of i32
pub const Vec4i = Vec(i32, 4);

/// 2d vector of u32
pub const Vec2u = Vec(u32, 2);
/// 3d vector of u32
pub const Vec3u = Vec(u32, 3);
/// 4d vector of u32
pub const Vec4u = Vec(u32, 4);

const st = std.testing;

test "add" {
    const a = Vec3u.init(.{1, 2, 3});
    const b = Vec3u.init(.{4, 5, 6});
    const c = a.add(b);
    try st.expectEqual(c.x, 5);
    try st.expectEqual(c.y, 7);
    try st.expectEqual(c.z, 9);
}