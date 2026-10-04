<?php
declare(strict_types=1);

require_once __DIR__ . '/../src/database.php';

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Headers: Content-Type, Authorization, bypass-tunnel-reminder');
header('Access-Control-Allow-Methods: GET, OPTIONS');

$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

if (PHP_SAPI === 'cli-server') {
    $staticFile = realpath(__DIR__ . $path);
    $publicRoot = realpath(__DIR__);

    if ($staticFile !== false && $publicRoot !== false && strpos($staticFile, $publicRoot) === 0 && (is_file($staticFile) || (is_dir($staticFile) && is_file(rtrim($staticFile, '/\\') . '/index.html')))) {
        return false;
    }
}
$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'OPTIONS') {
    http_response_code(204);
    exit;
}

if ($method !== 'GET') {
    json_response(['code' => 405, 'message' => 'Method Not Allowed'], 405);
}

try {
    switch ($path) {
        case '/':
        case '/index.html':
        case '/h5':
            header('Location: /h5/');
            exit;

        case '/api/health':
            $version = db()->query('SELECT VERSION()')->fetchColumn();
            json_response([
                'ok' => true,
                'database' => 'itbaizhan',
                'serverVersion' => $version,
            ]);
            break;

        case '/api/index/banner':
            $topBanner = fetch_all(
                "SELECT id, img_url, title FROM banners WHERE position = 'top' ORDER BY sort_order, id"
            );
            $indexBanner = fetch_one(
                "SELECT id, img_url, title FROM banners WHERE position = 'index' ORDER BY sort_order, id LIMIT 1"
            );
            $footBanner = fetch_one(
                "SELECT id, img_url, title FROM banners WHERE position = 'foot' ORDER BY sort_order, id LIMIT 1"
            );

            $topBanner = array_map(function (array $row): array {
                return with_asset($row, 'img_url');
            }, $topBanner);
            $indexBanner = $indexBanner ? with_asset($indexBanner, 'img_url') : ['img_url' => ''];
            $footBanner = $footBanner ? with_asset($footBanner, 'img_url') : ['img_url' => ''];

            json_response([
                'top_banner' => $topBanner,
                'index_banner' => $indexBanner,
                'foot_banner' => $footBanner,
            ]);
            break;

        case '/api/index/nav':
            $rows = fetch_all('SELECT id, title AS text, icon, course FROM nav_items ORDER BY sort_order, id');
            json_response(['code' => 0, 'message' => 'ok', 'data' => $rows]);
            break;

        case '/api/index/specific':
            $userId = isset($_GET['userid']) ? (int) $_GET['userid'] : 2162;
            $rows = fetch_all(
                'SELECT id, limit_name AS limitName, teacher_name, teacher_job, teacher_logo, limit_num AS limitNum, baoming
                 FROM specific_courses
                 WHERE user_id = ?
                 ORDER BY sort_order, id',
                [$userId]
            );
            $rows = array_map(function (array $row): array {
                $row['limitNum'] = (int) $row['limitNum'];

                return with_asset($row, 'teacher_logo');
            }, $rows);
            json_response(['code' => 0, 'message' => 'ok', 'data' => $rows]);
            break;

        case '/api/index/course':
            $rows = fetch_all(
                "SELECT id, text_t, description AS text, icon, colors, logo, hits
                 FROM courses
                 WHERE type = 'employment'
                 ORDER BY sort_order, id"
            );
            $rows = array_map(function (array $row): array {
                return [
                    'id' => (int) $row['id'],
                    'textT' => $row['text_t'],
                    'text' => $row['text'],
                    'icon' => $row['icon'],
                    'colors' => $row['colors'],
                    'logo' => asset_url($row['logo']),
                    'hits' => (int) $row['hits'],
                ];
            }, $rows);
            json_response(['code' => 0, 'message' => 'ok', 'data' => $rows]);
            break;

        case '/api/index/recommend':
            $rows = fetch_all(
                "SELECT id, text_t, description AS text, icon, colors, logo, hits
                 FROM courses
                 WHERE type = 'recommend'
                 ORDER BY sort_order, id"
            );
            $rows = array_map(function (array $row): array {
                return [
                    'id' => (int) $row['id'],
                    'textT' => $row['text_t'],
                    'text' => $row['text'],
                    'icon' => $row['icon'],
                    'colors' => $row['colors'],
                    'logo' => asset_url($row['logo']),
                    'hits' => (int) $row['hits'],
                ];
            }, $rows);
            json_response(['code' => 0, 'message' => 'ok', 'data' => $rows]);
            break;

        case '/api/course/detail':
            $courseId = isset($_GET['id']) ? (int) $_GET['id'] : 0;
            $detail = fetch_one(
                'SELECT course_id, introduce, image, height, title FROM course_details WHERE course_id = ?',
                [$courseId]
            );

            if ($detail === null) {
                json_response(['code' => 404, 'message' => 'Course not found', 'data' => null], 404);
            }

            $features = fetch_all(
                'SELECT num, txt FROM course_features WHERE course_id = ? ORDER BY sort_order, id',
                [$courseId]
            );
            $chapters = fetch_all(
                'SELECT id, type_name AS type_name FROM course_chapters WHERE course_id = ? ORDER BY sort_order, id',
                [$courseId]
            );

            json_response([
                'code' => 0,
                'message' => 'ok',
                'data' => [
                    'introduce' => $detail['introduce'],
                    'introduceList' => $features,
                    'Clist' => $chapters,
                    'image' => asset_url($detail['image']),
                    'height' => (string) $detail['height'],
                    'title' => $detail['title'],
                ],
            ]);
            break;

        case '/api/study/list':
            $userId = isset($_GET['userid']) ? (int) $_GET['userid'] : 2162;
            $rows = fetch_all(
                "SELECT sr.id,
                        sr.progress,
                        sr.learned_lessons,
                        sr.total_lessons,
                        sr.status,
                        DATE_FORMAT(sr.last_study_at, '%Y-%m-%d %H:%i') AS last_study_at,
                        c.id AS course_id,
                        c.text_t AS title,
                        c.description,
                        c.logo,
                        c.hits
                 FROM study_records sr
                 INNER JOIN courses c ON c.id = sr.course_id
                 WHERE sr.user_id = ?
                 ORDER BY sr.sort_order, sr.id",
                [$userId]
            );
            $rows = array_map(function (array $row): array {
                return [
                    'id' => (int) $row['id'],
                    'courseId' => (int) $row['course_id'],
                    'title' => $row['title'],
                    'description' => $row['description'],
                    'logo' => asset_url($row['logo']),
                    'progress' => (int) $row['progress'],
                    'learnedLessons' => (int) $row['learned_lessons'],
                    'totalLessons' => (int) $row['total_lessons'],
                    'lastStudyAt' => $row['last_study_at'],
                    'status' => $row['status'],
                    'hits' => (int) $row['hits'],
                ];
            }, $rows);
            json_response(['code' => 0, 'message' => 'ok', 'data' => $rows]);
            break;

        case '/api/user/profile':
            $userId = isset($_GET['userid']) ? (int) $_GET['userid'] : 2162;
            $profile = fetch_one(
                'SELECT user_id, nickname, avatar, bio, vip_level, study_days, total_hours
                 FROM user_profiles
                 WHERE user_id = ?',
                [$userId]
            );

            if ($profile === null) {
                json_response(['code' => 404, 'message' => 'User not found', 'data' => null], 404);
            }

            $summary = fetch_one(
                "SELECT COUNT(*) AS course_count,
                        COALESCE(ROUND(AVG(progress)), 0) AS avg_progress,
                        COALESCE(SUM(learned_lessons), 0) AS learned_lessons,
                        COALESCE(SUM(status = 'finished'), 0) AS finished_courses
                 FROM study_records
                 WHERE user_id = ?",
                [$userId]
            );
            $menus = fetch_all('SELECT id, title, icon, route, badge FROM user_menus ORDER BY sort_order, id');
            $menus = array_map(function (array $row): array {
                return [
                    'id' => (int) $row['id'],
                    'title' => $row['title'],
                    'icon' => $row['icon'],
                    'route' => $row['route'],
                    'badge' => $row['badge'],
                ];
            }, $menus);

            json_response([
                'code' => 0,
                'message' => 'ok',
                'data' => [
                    'userId' => (int) $profile['user_id'],
                    'nickname' => $profile['nickname'],
                    'avatar' => $profile['avatar'] === '' ? '' : asset_url($profile['avatar']),
                    'bio' => $profile['bio'],
                    'vipLevel' => $profile['vip_level'],
                    'studyDays' => (int) $profile['study_days'],
                    'totalHours' => (float) $profile['total_hours'],
                    'stats' => [
                        'courseCount' => (int) $summary['course_count'],
                        'avgProgress' => (int) $summary['avg_progress'],
                        'learnedLessons' => (int) $summary['learned_lessons'],
                        'finishedCourses' => (int) $summary['finished_courses'],
                    ],
                    'menus' => $menus,
                ],
            ]);
            break;

        case '/api/index/video':
            $video = fetch_one(
                'SELECT id, title, subtitle, video_url, poster_url, duration
                 FROM study_videos
                 ORDER BY sort_order, id
                 LIMIT 1'
            );

            if ($video === null) {
                json_response(['code' => 404, 'message' => 'Video not found', 'data' => null], 404);
            }

            json_response([
                'code' => 0,
                'message' => 'ok',
                'data' => [
                    'id' => (int) $video['id'],
                    'title' => $video['title'],
                    'subtitle' => $video['subtitle'],
                    'videoUrl' => asset_url($video['video_url']),
                    'posterUrl' => asset_url($video['poster_url']),
                    'duration' => (int) $video['duration'],
                ],
            ]);
            break;

        case '/api/user/orders':
            $userId = isset($_GET['userid']) ? (int) $_GET['userid'] : 2162;
            $rows = fetch_all(
                'SELECT o.id, o.order_no, o.amount, o.status, o.created_at, c.id AS course_id,
                        c.text_t AS title, c.description, c.logo
                 FROM user_orders o
                 INNER JOIN courses c ON c.id = o.course_id
                 WHERE o.user_id = ?
                 ORDER BY o.created_at DESC, o.id DESC',
                [$userId]
            );
            $rows = array_map(function (array $row): array {
                return [
                    'id' => (int) $row['id'],
                    'orderNo' => $row['order_no'],
                    'courseId' => (int) $row['course_id'],
                    'title' => $row['title'],
                    'description' => $row['description'],
                    'logo' => asset_url($row['logo']),
                    'amount' => (float) $row['amount'],
                    'status' => $row['status'],
                    'createdAt' => $row['created_at'],
                ];
            }, $rows);
            json_response(['code' => 0, 'message' => 'ok', 'data' => $rows]);
            break;

        case '/api/user/favorites':
            $userId = isset($_GET['userid']) ? (int) $_GET['userid'] : 2162;
            $rows = fetch_all(
                'SELECT f.id, f.created_at, c.id AS course_id, c.text_t AS title,
                        c.description, c.logo, c.hits
                 FROM user_favorites f
                 INNER JOIN courses c ON c.id = f.course_id
                 WHERE f.user_id = ?
                 ORDER BY f.created_at DESC, f.id DESC',
                [$userId]
            );
            $rows = array_map(function (array $row): array {
                return [
                    'id' => (int) $row['id'],
                    'courseId' => (int) $row['course_id'],
                    'title' => $row['title'],
                    'description' => $row['description'],
                    'logo' => asset_url($row['logo']),
                    'hits' => (int) $row['hits'],
                    'createdAt' => $row['created_at'],
                ];
            }, $rows);
            json_response(['code' => 0, 'message' => 'ok', 'data' => $rows]);
            break;

        case '/api/user/coupons':
            $userId = isset($_GET['userid']) ? (int) $_GET['userid'] : 2162;
            $rows = fetch_all(
                'SELECT id, title, amount, min_amount, expires_at, status
                 FROM user_coupons
                 WHERE user_id = ?
                 ORDER BY status, expires_at, id',
                [$userId]
            );
            $rows = array_map(function (array $row): array {
                return [
                    'id' => (int) $row['id'],
                    'title' => $row['title'],
                    'amount' => (float) $row['amount'],
                    'minAmount' => (float) $row['min_amount'],
                    'expiresAt' => $row['expires_at'],
                    'status' => $row['status'],
                ];
            }, $rows);
            json_response(['code' => 0, 'message' => 'ok', 'data' => $rows]);
            break;

        case '/api/user/settings':
            $userId = isset($_GET['userid']) ? (int) $_GET['userid'] : 2162;
            $settings = fetch_one(
                'SELECT message_notify, autoplay_video, download_quality FROM user_settings WHERE user_id = ?',
                [$userId]
            );
            if ($settings === null) {
                json_response(['code' => 404, 'message' => 'Settings not found', 'data' => null], 404);
            }
            json_response([
                'code' => 0,
                'message' => 'ok',
                'data' => [
                    'messageNotify' => (bool) $settings['message_notify'],
                    'autoplayVideo' => (bool) $settings['autoplay_video'],
                    'downloadQuality' => $settings['download_quality'],
                ],
            ]);
            break;

        default:
            json_response(['code' => 404, 'message' => 'API Not Found'], 404);
    }
} catch (Throwable $exception) {
    error_log($exception->getMessage());
    json_response([
        'code' => 500,
        'message' => 'Database connection failed',
        'error' => $exception->getMessage(),
    ], 500);
}