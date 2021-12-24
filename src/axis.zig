const std = @import("std");
const errors = @import("errors.zig");

pub fn Axis(comptime dimensions: comptime_int) type {
    comptime errors.assertValidDimensionCount(dimensions);
    return enum {
        x, y, z, w,
        const Self = @This();

        pub const dims = dimensions;

        pub const values = std.enums.values(Self)[0..dims];

    };
}