## Operation Queue

We need to refactor the Flask operation queue to use an Async operation instead of pausing/ releasing the queue

## Concerns

When initializing a substance wiuth the `NewSubstance(definedBy:)` we may need to consider how to handle naming.

## Nesting 

We may want to apply nesting on the nav hierarchy such that we can append another FlaskNavController as a child. 

If we do this we need to require passing the name

## Navigation Payload

By forcing the payload to be Codable, we can completely dehidrate and recreate the state of any view controller.
