# Important Contrasts Between TSNE and PCA

One thing to consider is that the result of PCA is a rotation matrix
which may be applied to any vector whatsoever of the appropriate
dimensionality. In particular, if you believe your original dataset is
statistically representative then the rotation matrix can reasonably be
applied to any new vectors you might have handed to you.

For example, it turns out to be the case that neural responses of the
sort we simulated in this lecture are conserved even across different
animals with similar physiology. That is, if we show two human beings
the same 60 second section of John Wick (and have them fix their eyes at
the center of the screen) then similar pyramidal cells in the visual
cortex will have similar firing patterns and membrane potentials.

Thus, if we have measured these voltages and found a useful set of
principal components, we might theoretically be able to re-use them in
later brain computer interfaces.

On the other hand, TSNE optimizes the configuration of representative
points in the training data. It doesn't provide a formula or method for
applying the resulting solution to new data, and so its utility for
future modeling is limited.

Rule of Thumb: TSNE for visualization, PCA for pre-treatment.


Next: ::11_metric-spaces-and-dimensionality-reduction:Metric Spaces and Dimensionality Reduction::
