const assert = require('assert');

describe('Mathematical Operations - Test Suite', function() {
    this.timeout(500);
    const a = 20;
    const b = 10;

    it('Addition of two variables', function(done) {
        this.timeout(300);
        setTimeout(done,100);
        const c = a+b;
        assert.equal(c,30);
    });
    
    it('Substraction of two variables', function() {
        const c = a-b;
        assert.equal(c,10);
    });

    it('Multiplication of two variables', function() {
        const c = a*b;
        assert.equal(c,200);
    });

    it('Division of two variables', function() {
        const c = a/b;
        assert.equal(c,2);
    });
});