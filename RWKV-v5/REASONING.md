Can convert any v7 model to reason by training more!
Models are saved in the exact same format (meaning that you can inference them however and choose how many times to loop over the reasoning layers(for more or less thinking))
Can scale up the thinking iters during training slowly.
Can experiment with differen iter counts for time mix or channel mix or even not doing it for time mix at all. (not sure if state gets weird from doing this)
Can experiment on a layer deeper than timemix/channelmix.
Can experiment with special modules which are fully focused on just reasoning.
Can experiment alternating att and ffn layers for reasoning (the full block module instead)

Mess with optimizer scaling for the modules run multiple times.
Pass x_embed to the tied weights module, each feature in the embedding should contribute to a single linear layer which picks an amount of reasoning iterations to use. (how the fuck can i do this where it picks an amount)

Need to test upgrading models next

If we need to scale the reasoning up, it might be worth scaling to tied weights on whole groups of blocks (instead of repeating FFN/ATT repeat a GROUP of blocks), these blocks can be actually tiny blocks instead of the massive ones we use.
NEED TO GRADIENT CP