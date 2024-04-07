<?php

require 'vendor/aws-autoloader.php';

use Aws\DynamoDb\Exception\DynamoDbException;
use Aws\DynamoDb\DynamoDbClient;

// Set correct content type for JSON response
header('Content-Type: application/json');

// Initialize DynamoDB client to use IAM Role of EC2 Instance
$dynamoDb = new DynamoDbClient([
    'region' => 'eu-north-1', // Specify your AWS region
    'version' => 'latest',
]);

$tableName = 'UserData';

// Check if the request is POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Sanitize input
    $username = strip_tags($_POST['username']);
    $password = $_POST['password']; // No need to sanitize a password before hashing it

    // Hash password
    $hashedPassword = password_hash($password, PASSWORD_DEFAULT);

    // Generate a unique ID for the primary key
    $userId = uniqid('user_', true);

    // Construct the item to insert
    $item = [
        'TableName' => $tableName,
        'Item' => [
            'UserId'    => ['S' => $userId],
            'UserName'  => ['S' => $username],
            'UserPass'  => ['S' => $hashedPassword],
        ]
    ];

    try {
        $result = $dynamoDb->putItem($item);
        echo json_encode(['message' => 'Data saved successfully']);
    } catch (DynamoDbException $e) {
        // Error handling
        http_response_code(500);
        echo json_encode(['error' => 'Failed to save data', 'details' => $e->getMessage()]);
    }
} else {
    // Respond to non-POST requests
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed']);
}
