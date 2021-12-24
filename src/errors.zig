const std = @import("std");

pub fn assertValidDimensionCount(comptime dim: comptime_int) void {
    switch (dim) {
        2, 3, 4 => {},
        else => @compileError("only 2, 3, or 4 dimensions allowed"),
    }
}