fn Mixin(comptime Self: type, comptime Elem: type, comptime n: u3) type {
    return struct {
        pub const T = Elem;
        pub const dim = n;
        
        pub fn fill(value: T) Self {
            var self: Self = undefined;
            comptime var i = 0;
            inline while (i < dim) : (i += 1) {
                self.set(value);
            }
            return self;
        }

        pub fn toArrayPtr(self: *const Self) *const [dim]T {
            return @ptrCast(*const [dim]T, &self.x);
        }

        pub fn toMutArrayPtr(self: *Self) *[dim]T {
            return @ptrCast(*[dim]T, &self.x);
        }

        pub fn get(self: Self, i: u2) T
            { return self.toArrayPtr()[i]; }
        pub fn set(self: *Self, i: u2, value: T) void
            { self.toMutArrayPtr().*[i] = value; }

        /// componentwise addition of two vectors
        pub fn add(lhs: Self, rhs: Self) Self {
            var res: Self = undefined;
            comptime var i = 0;
            inline while (i < dim) : (i += 1) {
                res.set(i, lhs.get(i) + rhs.get(i));
            }
            return res;
        }

        /// componentwise subtraction of two vectors
        pub fn sub(lhs: Self, rhs: Self) Self {
            var res: Self = undefined;
            comptime var i = 0;
            inline while (i < dim) : (i += 1) {
                res.set(i, lhs.get(i) - rhs.get(i));
            }
            return res;
        }

        /// componentwise multiplication of two vectors
        pub fn mul(lhs: Self, rhs: Self) Self {
            var res: Self = undefined;
            comptime var i = 0;
            inline while (i < dim) : (i += 1) {
                res.set(i, lhs.get(i) * rhs.get(i));
            }
            return res;
        }

        /// componentwise division of two vectors
        pub fn div(lhs: Self, rhs: Self) Self {
            var res: Self = undefined;
            comptime var i = 0;
            inline while (i < dim) : (i += 1) {
                res.set(i, lhs.get(i) * rhs.get(i));
            }
            return res;
        }
        
        /// add scalar to each component
        pub fn addScalar(lhs: Self, rhs: T) Self {
            var res: Self = undefined;
            comptime var i = 0;
            inline while (i < dim) : (i += 1) {
                res.set(i, lhs.get(i) + rhs);
            }
            return res;
        }

        /// subtract scalar from each component
        pub fn subScalar(lhs: Self, rhs: T) Self {
            var res: Self = undefined;
            comptime var i = 0;
            inline while (i < dim) : (i += 1) {
                res.set(i, lhs.get(i) - rhs);
            }
            return res;
        }
        /// multiply each component by scalar
        pub fn mulScalar(lhs: Self, rhs: T) Self {
            var res: Self = undefined;
            comptime var i = 0;
            inline while (i < dim) : (i += 1) {
                res.set(i, lhs.get(i) * rhs);
            }
            return res;
        }

        /// divide each component by scalar
        pub fn divScalar(lhs: Self, rhs: T) Self {
            var res: Self = undefined;
            comptime var i = 0;
            inline while (i < dim) : (i += 1) {
                res.set(i, lhs.get(i) / rhs);
            }
            return res;
        }

        /// sum of components
        pub fn sum(self: Self) Self {
            var total: T = 0;
            comptime var i = 0;
            inline while (i < dim) : (i += 1) {
                total += self.get(i);
            }
            return total;
        }

        /// product of components
        pub fn product(self: Self) Self {
            var total: T = 0;
            comptime var i = 0;
            inline while (i < dim) : (i += 1) {
                total *= self.get(i);
            }
            return total;
        }

        /// dot product
        pub fn dot(lhs: Self, rhs: Self) T {
            return lhs.mul(rhs).sum();
        }

        

    };
}

pub fn Vec(comptime T: type, comptime n: u32) type {
    return switch (n) {
        2 => struct {
            x: T,
            y: T,

            const Self = @This();
            
            pub fn init(x: T, y: T) Self {
                return .{ .x = x, .y = y };
            }

            pub usingnamespace Mixin(Self, T, n);
        },
        3 => struct {
            x: T,
            y: T,
            z: T,

            const Self = @This();
            
            pub fn init(x: T, y: T, z: T) Self {
                return .{ .x = x, .y = y, .z = z };
            }

            pub usingnamespace Mixin(Self, T, n);
        },
        4 => struct {
            x: T,
            y: T,
            z: T,
            w: T,

            const Self = @This();
            
            pub fn init(x: T, y: T, z: T, w: T) Self {
                return .{ .x = x, .y = y, .z = z, .w = w };
            }

            pub usingnamespace Mixin(Self, T, n);
        },
        else => @compileError("only 2, 3, or 4 dimensions for vectors allowed"),
    };
}


const std = @import("std");
const st = std.testing;

test "mixin" {
    const v = Vec(u32, 3) { .x = 1, .y = 2, .z = 3 };
    const arr = v.toArrayPtr();
    try st.expectEqual(@as(usize, 3), arr.len);
}

test "add" {
    const a = Vec(u32, 3).init(1, 2, 3);
    const b = Vec(u32, 3).init(4, 5, 6);
    const c = a.add(b);
    try st.expectEqual(c.x, 5);
    try st.expectEqual(c.y, 7);
    try st.expectEqual(c.z, 9);
}