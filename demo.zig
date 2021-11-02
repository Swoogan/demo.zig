const std = @import("std");

const allocator = std.heap.wasm_allocator;

// pub extern fn getImageData(x: f32, y: f32, width: f32, height: f32) void;
// pub extern fn putImageData(imageData, x: f32, y: f32) void;
// pub extern fn consoleLog(_: c_int) void;
// pub extern fn consoleLogF(_: f32) void;
// pub extern fn log(_: [*]const u8, _: c_uint) void;
pub extern fn setPixel(x: f32, y: f32) void;
pub extern fn getRandom() f32;
pub extern fn hello() void;

const Point = packed struct {
    x: f32,
    y: f32,
};

const origin = Point { .x = 320, .y = 240 };

const r: f32 = 50;
var t: f32 = 0;
var step: f32 = 0.1;
var rain = init: {
    var initial_value: [640]Point = undefined;
    for (initial_value) |*pt, i| {
        pt.* = Point{
            .x = @floatCast(f32, @as(f32, i)),
            .y = @floatCast(f32, 0),
        };
    }
    break :init initial_value;
};

export fn render() void {
    var x_rand = getRandom() * 640;
    setPixel(x_rand * 640, origin.y);

    for (rain) |*pt, i| {
        setPixel(pt.x, pt.y);
    }

    const x = origin.x + r * @sin(t);
    const y = origin.y + r * @cos(t);
    setPixel(x, y);
    if (t >= 10) return;
    t += step;
    
    // hello();

}

