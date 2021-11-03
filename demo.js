var memory = new WebAssembly.Memory({ initial: 10, maximum: 100 });

let world = {
    width: 640,
    height: 480,
};

let c = document.getElementById("screen");
c.width = world.width;
c.height = world.height;

let ctx = c.getContext("2d");

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
        log: (arg) => console.log(arg),
        setPixel: (x, y) => drawPixel(x, y),
        hello: () => console.log("hello"),
        getRandom: () => Math.random(),
    }
};

WebAssembly.instantiateStreaming(fetch('demo.wasm'), importObject)
    .then(assembly => {
        const update = assembly.instance.exports.update;
        const render = assembly.instance.exports.render;

        assembly.instance.exports.initialize();

        function main() {
            clear();
            ctx.beginPath();
            update();
            render();
            ctx.closePath();
        }

        main();

        setInterval(main, 16);
    });
