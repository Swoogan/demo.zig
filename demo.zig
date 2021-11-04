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

//const height: usize = 320;
const fps: u32 = 60;
const frame: u32 = 16;
const drop_rate: u32 = frame * 2;
const width: f32 = 640;
const origin = Point { .x = 320, .y = 240 };

var time: u32 = 0;

// circle data
const r: f32 = 50;
var t: f32 = 0;
var step: f32 = 0.1;

// rain data
var rain = init: {
    var initial_value: [width]Point = undefined;
    for (initial_value) |*pt, i| {
        pt.* = Point{
            .x = @floatCast(f32, @as(f32, i)),
            .y = @floatCast(f32, 0),
        };
    }
    break :init initial_value;
};

var rain_index: usize = 0;
var falling_rain: [width]*Point = undefined;

fn swap(x: *Point, y: *Point) void {
    const temp = x.*;
    x.* = y.*;
    y.* = temp;
}

export fn initialize() void {
    for (rain) |_, i| {
        const rnd = @floatToInt(usize, getRandom() * width);
        swap(&rain[i], &rain[rnd]);
    }
}

fn update_rain() void {
    if (rain_index > width) {
        return;
    }

    if (time % drop_rate == 0) {
        const drop = &rain[rain_index];
        falling_rain[rain_index] = drop;
    }

    for (falling_rain) |drop| {
        drop.y += 10;

        //if (drop.y > 480) {
            //rain_index += 1;
        //}
    }

    rain_index += 1;
}

export fn update() void {
    update_rain();
    time += frame;
}

export fn render() void {
    // draw rain
    for (rain) |*pt| {
        setPixel(pt.x, pt.y);
    }
}

