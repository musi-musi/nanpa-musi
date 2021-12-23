const std = @import("std");

pub fn compileErrorInvalidDimensionCount() void {
    @compileError("only 2, 3, or 4 dimensions allowed");
}