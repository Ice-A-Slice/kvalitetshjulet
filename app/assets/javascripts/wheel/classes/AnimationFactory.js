var AnimationFactory = new function() {}

AnimationFactory.prototype = {
    callAnimations: function(arr) {
        for (var i = 0, ani; ani = arr[i++];) {
            var _this = this;
            if (!AnimationFactory.funcs[ani]) throw new Error('Could not find an animation called ' + ani);
            _this.animations[ani] = new Kinetic.Animation(AnimationFactory.funcs[ani], this.getLayer());

            _this['animate' + ani.capitalizeFirstLetter()] = (function(ani) {
                return function() {
                    _this.animations[ani].start();
                    return this;
                }
            })(ani);
        }
    }
}

AnimationFactory.funcs = {
    hide: function(frame) {
        var l = this.getLayers()[0];
        var op = l.getOpacity() - (frame.timeDiff / AnimationFactory.DEFAULT_SPEED);
        if (op < 0) {
            l.hide();
            this.stop();
            return;
        }
        l.getLayer().opacity(op);
    },
    show: function(frame) {
        var l = this.getLayers()[0];
        l.show();
        var op = l.getOpacity() + (frame.timeDiff / AnimationFactory.DEFAULT_SPEED);
        if (op > 1) {
            l.show();
            this.stop();
            return;
        }
        l.getLayer().opacity(op)
    }
}

AnimationFactory.DEFAULT_SPEED = 250;