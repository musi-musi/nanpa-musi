const std = @import("std");
const meta = std.meta;
const errors = @import("errors.zig");

const axis = @import("axis.zig");

pub fn Vec(comptime ElemType: type, comptime dimensions: u32) type {
    comptime errors.assertValidDimensionCount(dimensions);
    return struct {
        x: T,
        y: T,
        z: if (dims > 2) T else void,
        w: if (dims > 3) T else void,

        const Self = @This();

        pub const T = ElemType;
        pub const dims = dimensions;

        pub const Axis = axis.Axis(dims);
        
        pub const ElemArray = [dims]T;

        pub fn init(arr: ElemArray) Self {
            var self: Self = undefined;
            inline for (Axis.values) |a| {
                self.set(a, arr[@enumToInt(a)]);
            }
            return self;
        }

        pub fn fill(value: T) Self {
            var self: Self = undefined;
            inline for (Axis.values) |a| {
                self.set(a, value);
            }
            return self;
        }

        pub fn toArrayPtr(self: *const Self) *const [dims]T
            { return @ptrCast(*const [dims]T, &self.x); }
        pub fn toMutArrayPtr(self: *Self) *[dims]T
            { return @ptrCast(*[dims]T, &self.x); }

        pub fn get(self: Self, comptime a: Axis) T
            { return self.toArrayPtr()[@enumToInt(a)]; }
        pub fn set(self: *Self, comptime a: Axis, value: T) void
            { self.toMutArrayPtr().*[@enumToInt(a)] = value; }
        
        pub fn geti(self: Self, i: u32) T
            { return self.toArrayPtr()[i]; }
        pub fn seti(self: *Self, i: u32, value: T) void
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
        pub fn addScalar(lhs: Self, rhs: T) Self {
            var res: Self = undefined;
            inline for (Axis.values) |a|
                res.set(a, lhs.get(a) + rhs);
            return res;
        }

        /// subtract scalar from each component
        pub fn subScalar(lhs: Self, rhs: T) Self {
            var res: Self = undefined;
            inline for (Axis.values) |a|
                res.set(a, lhs.get(a) - rhs);
            return res;
        }
        /// multiply each component by scalar
        pub fn mulScalar(lhs: Self, rhs: T) Self {
            var res: Self = undefined;
            inline for (Axis.values) |a|
                res.set(a, lhs.get(a) * rhs);
            return res;
        }

        /// divide each component by scalar
        pub fn divScalar(lhs: Self, rhs: T) Self {
            var res: Self = undefined;
            inline for (Axis.values) |a|
                res.set(a, lhs.get(a) / rhs);
            return res;
        }

        /// sum of components
        pub fn sum(self: Self) Self {
            var total: T = 0;
            inline for (Axis.values) |a|
                total += self.get(a);
            return total;
        }

        /// product of components
        pub fn product(self: Self) Self {
            var total: T = 0;
            inline for (Axis.values) |a|
                total *= self.get(a);
            return total;
        }

        /// dot product
        pub fn dot(lhs: Self, rhs: Self) T {
            return lhs.mul(rhs).sum();
        }

        /// square magnitude
        pub fn mag2(self: Self) T {
            return self.dot(self);
        }

        /// magnitude
        pub fn mag(self: Self) T {
            return std.math.sqrt(self.mag2());
        }
        

    };
}


const st = std.testing;

test "add" {
    const a = Vec(u32, 3).init(.{1, 2, 3});
    const b = Vec(u32, 3).init(.{4, 5, 6});
    const c = a.add(b);
    try st.expectEqual(c.x, 5);
    try st.expectEqual(c.y, 7);
    try st.expectEqual(c.z, 9);
}