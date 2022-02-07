const std = @import("std");
const asserts = @import("asserts.zig");
const vector = @import("vector.zig");

pub fn Matrix(comptime Scalar_: type, comptime rows_: comptime_int, comptime cols_: comptime_int) type {
    comptime asserts.assertFloat(Scalar_);
    comptime asserts.assertValidDimensionCount(rows_);
    comptime asserts.assertValidDimensionCount(cols_);
    if (rows_ != cols_) @compileError("TODO: support non-square mats"); // TODO: support non-square mats
    return struct {
        v: Value,

        pub const Value = [rows][cols]Scalar;

        pub const Scalar = Scalar_;
        pub const Vector = vector.Vector(Scalar, rows);
        pub const rows = rows_;
        pub const cols = cols_;

        pub const row_indices = ([_]usize{ 0, 1, 2, 3, })[0..rows];
        pub const col_indices = ([_]usize{ 0, 1, 2, 3, })[0..cols];

        const Self = @This();
        
        pub const zero = fill(0);
        pub const identity = blk: {
            var id = zero;
            for (row_indices) |r| {
                id.v[r][r] = 1;
            }
            break :blk id;
        };

        pub fn fill(v: Scalar) Self {
            var self: Self = undefined;
            inline for(row_indices) |r| {
                inline for(col_indices) |c| {
                    self.v[r][c] = v;
                }
            }
            return self;
        }

        pub fn transform(self: Self, vec: Vector) Vector {
            var res = Vector.zero;
            inline for(col_indices) |c| {
                inline for(row_indices) |r| {
                    res.v[r] += vec.v[c] * self.v[r][c];
                }
            }
            return res;
        }

        pub fn mul(ma: Self, mb: Self) Self {
            // TODO: support non-square mats
            var res: Self = undefined;
            inline for (rows) |r| {
                inline for (cols) |c| {
                    var sum: Scalar = 0;
                    inline for (rows) |i| {
                        sum += ma.v[r][i] * mb.v[i][c];
                    }
                    res.v[r][c] = sum;
                }
            }
            return res;
        }

        pub fn transpose(self: Self) Self {
            var res: Self = undefined;
            inline for (rows) |r| {
                inline for (cols) |c| {
                    res.v[r][c] = self.v[c][r];
                }
            }
            return res;
        }


    };
}

pub const Mat2 = Matrix(f32, 2, 2);
pub const Mat3 = Matrix(f32, 3, 3);
pub const Mat4 = Matrix(f32, 4, 4);

pub const Mat2d = Matrix(f64, 2, 2);
pub const Mat3d = Matrix(f64, 3, 3);
pub const Mat4d = Matrix(f64, 4, 4);