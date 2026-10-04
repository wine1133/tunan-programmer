<?php
declare(strict_types=1);

function env_value(string $name, string $default): string
{
    $value = getenv($name);

    return ($value === false || $value === '') ? $default : $value;
}

return [
    'host' => env_value('DB_HOST', '127.0.0.1'),
    'port' => (int) env_value('DB_PORT', '3306'),
    'database' => env_value('DB_DATABASE', 'itbaizhan'),
    'username' => env_value('DB_USERNAME', 'itbaizhan_app'),
    'password' => env_value('DB_PASSWORD', 'itbaizhan_dev_2026'),
    'charset' => 'utf8mb4',
];