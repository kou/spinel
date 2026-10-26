# An Integer#times count and an upto / downto limit are taken once, as Ruby
# takes them, whatever the loop's body or code it runs changes: a local the
# body assigns or binds (a `for` index, a pattern), an ivar, a global, a
# constant, a local a proc or a trap assigns, and an expression over a
# local. A limit is taken after the receiver, and a side-effecting Float
# one as a Float.

n = 5
c = 0
n.times { |i| n = 2; c += 1 }
p c

class K
  def initialize; @n = 5; end
  def run
    c = 0
    @n.times { |i| @n = 2; c += 1 }
    c
  end
end
p K.new.run

$g = 5
c = 0
$g.times { |i| $g = 2; c += 1 }
p c

n = 5
f = -> { n = 2 }
c = 0
n.times { |i| f.call; c += 1 }
p c

n = 3
c = 0
(n * 2).times { |i| n = 1; c += 1 }
p c

n = 5
Signal.trap("USR1") { n = 2 }
c = 0
n.times { |i| Process.kill("USR1", Process.pid) if i == 0; sleep 0.01; c += 1 }
p c

m = 5
c = 0
0.upto(m) { |i| m = 1; c += 1 }
p c

m = 0
c = 0
5.downto(m) { |i| m = 4; c += 1 }
p c

m = 4.5
c = 0
0.upto(m) { |i| m = 1.5; c += 1 }
p c

k = 4
c = 0
k.times { |i| c += i }
p c

# a side-effecting Float limit is taken once as a Float, not cut to an Integer
def lim; -1.5; end
a = []
-3.upto(lim) { |i| a << i }
p a

# a local the body binds without assigning it
m = 5
c = 0
0.upto(m) { for m in [1]; end; c += 1 }
p c
k = 5
c = 0
k.times { for k in [1]; end; c += 1 }
p c
n = 5
c = 0
n.times { case 2; in n; end; c += 1 }
p c

# a constant the body reassigns
N = 5
c = 0
N.times { N = 1; c += 1 }
p c

# the receiver ahead of the limit
def bump; $lim = 3; 0; end
$lim = 1
c = 0
bump.upto($lim) { c += 1 }
p c
