# Vector Spaces

PCA finds a rotation which aligns axes of variation with the axes of our
coordinate system. This rotation is then applied to each element of our
data set individually. The only mathematical objects you can rotate are
vectors.

A vector space is a set V along with a field F such that the following
are true:

$$
\begin{array}{l}
u, v, w \in V \\
a, b \in F \\
u + (v + w) = (u + v) + w \\
u + v = v + u \\
v + 0 = v \\
a(bv) = (ab)v \\
1v = v \\
a(u+v) = au + av \\
(a+b)v = av + bv
\end{array}
$$

Any combination of a set and a field which satisfies these axioms is a
vector space. But these are quite powerful and thus restrictive. Just
for instance, we must be able to add two vectors to get another.
Consider a simple data set consisting of pairs of weights and heights of
human beings. What does it mean to *add* two elements of this set?

What about to multiply an element by 10. By 1000?


Next: ::07_manifolds:Manifolds::
