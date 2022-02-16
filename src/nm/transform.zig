const std = @import("std");
const math = std.math;

const asserts = @import("asserts.zig");
const vector = @import("vector.zig");
const matrix = @import("matrix.zig");

fn transformGeneric(comptime Scalar: type) type {
    comptime asserts.assertFloat(Scalar);
    return struct {

        pub const Vec3 = vector.Vector(Scalar, 3);
        pub const Vec4 = vector.Vector(Scalar, 4);
        pub const Mat4 = matrix.Matrix(Scalar, 4, 4);

        pub fn createLook(eye: Vec3, direction: Vec3, up: Vec3) Mat4 {
            const f = direction.norm();
            const s = up.cross(f).norm();
            const u = f.cross(s);
            var result = Mat4.identity;
            result.v[0][0] = s.x;
            result.v[1][0] = s.y;
            result.v[2][0] = s.z;
            result.v[0][1] = u.x;
            result.v[1][1] = u.y;
            result.v[2][1] = u.z;
            result.v[0][2] = f.x;
            result.v[1][2] = f.y;
            result.v[2][2] = f.z;
            result.v[3][0] = -s.dot(eye);
            result.v[3][1] = -u.dot(eye);
            result.v[3][2] = -f.dot(eye);
            return result;
        }

        pub fn createLookAt(eye: Vec3, target: Vec3, up: Vec3) Mat4 {
            return createLook(eye, target.sub(eye), up);
        }

        pub fn createPerspective(fov: Scalar, aspect: Scalar, near: Scalar, far: Scalar) Mat4 {
            const tan = std.math.tan(fov / 2);
            var result = Mat4.zero;
            result.v[0][0] = 1.0 / (aspect * tan);
            result.v[1][1] = 1.0 / (tan);
            result.v[2][2] = far / (far - near);
            result.v[2][3] = 1;
            result.v[3][2] = -(far * near) / (far - near);
            return result;
        }

    };
}

pub const transform = transformGeneric(f32);