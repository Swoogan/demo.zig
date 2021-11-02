var memory = new WebAssembly.Memory({ initial: 10, maximum: 100 });

let world = {
    width: 640,
    height: 480,
};

let c = document.getElementById("screen");
c.width = world.width;
c.height = world.height;

let ctx = c.getContext("2d");

// function drawPixel(x, y, colour) {
function drawPixel(x, y) {
    ctx.fillStyle = 'black';
    ctx.rect(x, y, 2, 2);
    ctx.fill();
}

function clear() {
    ctx.clearRect(0, 0, world.width, world.height);
}

var importObject = {
    env: {
        log: function(arg) {
            console.log(arg);
        },
        setPixel: (x, y) => drawPixel(x, y),
        hello: function() {
            console.log("hello");
        }
    }
};

WebAssembly.instantiateStreaming(fetch('add-wasm.wasm'), importObject)
    .then(assembly => {
        const render = assembly.instance.exports.render;

        function main() {
            clear();
            ctx.beginPath();
            render();
            ctx.closePath();
        }

        main();

        setInterval(main, 16);
    });
