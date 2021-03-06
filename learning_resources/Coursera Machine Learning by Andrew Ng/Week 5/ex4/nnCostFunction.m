function [J, grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);

% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

X = [ones(m, 1), X];

hidden_z = X * Theta1';
hidden_a = sigmoid(hidden_z);
hidden_a = [ones(m, 1), hidden_a];

output_z = hidden_a * Theta2';
output_a = sigmoid(output_z);

y_onehot = onehot_encoding(y, num_labels);

%% Calculate J with Regularized Theta1 and Theta2

Theta1_nb = Theta1(:, 2:input_layer_size+1);
Theta2_nb = Theta2(:, 2:hidden_layer_size+1);

error_mat = -y_onehot.*log(output_a) - (1-y_onehot).*log(1-output_a);

J = sum( error_mat(:)) / m + (sum(Theta1_nb(:).^2) + ...
    sum(Theta2_nb(:).^2)) * lambda / (2*m);


%% Calculate Gradient
delta_output = output_a - y_onehot;
Theta2_grad = delta_output' * hidden_a / m; % 10 x 26

delta_hidden = delta_output * Theta2 .* [zeros(m, 1), sigmoidGradient(hidden_z)];
delta_hidden = delta_hidden(:, 2:hidden_layer_size+1);
Theta1_grad = delta_hidden' * X / m; % 25 x 401


% Regulartization
Theta2_grad(:, 2:hidden_layer_size+1) = ...
    Theta2_grad(:, 2:hidden_layer_size+1) + ...
    lambda * Theta2(:, 2:hidden_layer_size+1) / m;
 
Theta1_grad(:, 2:input_layer_size+1) = ...
    Theta1_grad(:, 2:input_layer_size+1) + ...
    lambda * Theta1(:, 2:input_layer_size+1) / m;



% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
