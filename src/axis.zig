const std = @import("std");
const asserts = @import("asserts.zig");

pub fn Axis(comptime dimensions: comptime_int) type {
    comptime asserts.assertValidDimensionCount(dimensions);
    return enum {
        x, y, z, w,
        const Self = @This();

        pub const dims = dimensions;

        pub const values = std.enums.values(Self)[0..dims];

        /// convert to the same value in a different number of dimensions
        pub fn cast(self: Self, comptime dest_dims: comptime_int) Axis(dest_dims) {
            return @intToEnum(Axis(dest_dims), @enumToInt(self));
        }

    };
}

pub const Axis2 = Axis(2);
pub const Axis3 = Axis(3);
pub const Axis4 = Axis(4);