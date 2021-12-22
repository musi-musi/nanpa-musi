fn Mixin(comptime Self: type, comptime T: type, comptime n: u3) type {
    return struct {
        pub const Elem = T;
        pub const dim = n;
        
        pub fn toArrayPtr(self: *const Self) *const [dim]Elem callconv (.inline) {
            return @ptrCast(*const [dim]Elem, &self.x);
        }

        pub fn toMutArrayPtr(self: *Self) *[dim]Elem {
            return @ptrCast(*[dim]Elem, &self.x);
        }

        pub fn get(self: Self, i: u2) Elem
            { return self.toArrayPtr()[i]; }
        pub fn set(self: *Self, i: u2, value: Elem) void
            { self.toMutArrayPtr().*[i] = value; }

        pub fn add(lhs: Self, rhs: Self) Self {
            var res: Self = undefined;
            comptime var i = 0;
            inline while (i < dim) : (i += 1) {
                res.set(i, lhs.get(i) + rhs.get(i));
            }
            return res;
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