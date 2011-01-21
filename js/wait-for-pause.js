the waiting-for-pause trick:
    // execute callback only after a pause in user input; the function returned
    // can be used to handle an event type that tightly repeats (such as typing
    // or scrolling events); it will execute the callback only if the given timout
    // period has passed since the last time the same event fired
    function createOnPause(callback, timeout, _this) {
        return function(e) {
            var _that = this;
            if (arguments.callee.timer)
                clearTimeout(arguments.callee.timer);
            arguments.callee.timer = setTimeout(function() { 
                callback.call(_this || _that, e);
            }, timeout);
        }
    }
Use it like this:
    document.addEventListener('scroll', createOnPause(function(e) {
        // do something interesting here
    }, 1500, this), false);
