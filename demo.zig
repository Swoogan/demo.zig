const std = @import("std");

const allocator = std.heap.wasm_allocator;

// pub extern fn getImageData(x: f32, y: f32, width: f32, height: f32) void;
// pub extern fn putImageData(imageData, x: f32, y: f32) void;
// pub extern fn consoleLog(_: c_int) void;
// pub extern fn consoleLogF(_: f32) void;
// pub extern fn log(_: [*]const u8, _: c_uint) void;
pub extern fn setPixel(x: f32, y: f32) void;
pub extern fn hello() void;

const Point = packed struct {
    x: f32,
    y: f32,
};

const origin = Point { .x = 320, .y = 240 };

const r: f32 = 50;
var t: f32 = 0;
var step: f32 = 0.1;
var prng = std.rand.DefaultPrng.init(0xdeadbeef);
// var r = std.rand.Rand.init(0xdeadbeef);
const x_rand: f32 = prng.float(f32);

export fn render() void {
    setPixel(x_rand, origin.y);
    const x = origin.x + r * @sin(t);
    const y = origin.y + r * @cos(t);
    setPixel(x, y);
    if (t >= 10) return;
    t += step;
    
    // hello();

}

