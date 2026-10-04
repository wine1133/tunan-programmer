CREATE DATABASE IF NOT EXISTS `itbaizhan`
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE `itbaizhan`;

CREATE USER IF NOT EXISTS 'itbaizhan_app'@'localhost'
    IDENTIFIED WITH mysql_native_password BY 'itbaizhan_dev_2026';
CREATE USER IF NOT EXISTS 'itbaizhan_app'@'127.0.0.1'
    IDENTIFIED WITH mysql_native_password BY 'itbaizhan_dev_2026';
GRANT SELECT, INSERT, UPDATE, DELETE ON `itbaizhan`.* TO 'itbaizhan_app'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON `itbaizhan`.* TO 'itbaizhan_app'@'127.0.0.1';
FLUSH PRIVILEGES;

CREATE TABLE IF NOT EXISTS `banners` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `position` ENUM('top', 'index', 'foot') NOT NULL,
    `img_url` VARCHAR(500) NOT NULL,
    `title` VARCHAR(120) NOT NULL DEFAULT '',
    `sort_order` INT NOT NULL DEFAULT 0,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_banners_position_sort` (`position`, `sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `nav_items` (
    `id` INT UNSIGNED NOT NULL,
    `title` VARCHAR(60) NOT NULL,
    `icon` VARCHAR(100) NOT NULL,
    `course` VARCHAR(20) NOT NULL DEFAULT 'no',
    `sort_order` INT NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `specific_courses` (
    `id` INT UNSIGNED NOT NULL,
    `user_id` INT UNSIGNED NOT NULL DEFAULT 2162,
    `limit_name` VARCHAR(160) NOT NULL,
    `teacher_name` VARCHAR(60) NOT NULL,
    `teacher_job` VARCHAR(60) NOT NULL DEFAULT '',
    `teacher_logo` VARCHAR(500) NOT NULL,
    `limit_num` INT UNSIGNED NOT NULL DEFAULT 0,
    `baoming` VARCHAR(30) NOT NULL DEFAULT '立即报名',
    `sort_order` INT NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_specific_user_sort` (`user_id`, `sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `courses` (
    `id` INT UNSIGNED NOT NULL,
    `type` ENUM('employment', 'recommend') NOT NULL,
    `text_t` VARCHAR(160) NOT NULL,
    `description` VARCHAR(255) NOT NULL DEFAULT '',
    `icon` VARCHAR(100) NOT NULL DEFAULT '',
    `colors` VARCHAR(60) NOT NULL DEFAULT '',
    `logo` VARCHAR(500) NOT NULL,
    `hits` INT UNSIGNED NOT NULL DEFAULT 0,
    `sort_order` INT NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_courses_type_sort` (`type`, `sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `course_details` (
    `course_id` INT UNSIGNED NOT NULL,
    `title` VARCHAR(160) NOT NULL,
    `introduce` TEXT NOT NULL,
    `image` VARCHAR(500) NOT NULL,
    `height` VARCHAR(20) NOT NULL DEFAULT '540',
    PRIMARY KEY (`course_id`),
    CONSTRAINT `fk_course_details_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `course_features` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `course_id` INT UNSIGNED NOT NULL,
    `num` VARCHAR(30) NOT NULL,
    `txt` VARCHAR(60) NOT NULL,
    `sort_order` INT NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_course_feature_order` (`course_id`, `sort_order`),
    CONSTRAINT `fk_course_features_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `course_chapters` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `course_id` INT UNSIGNED NOT NULL,
    `type_name` VARCHAR(180) NOT NULL,
    `sort_order` INT NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_course_chapter_order` (`course_id`, `sort_order`),
    CONSTRAINT `fk_course_chapters_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `banners` (`id`, `position`, `img_url`, `title`, `sort_order`) VALUES
    (1, 'top', '/static/demo/banner-1.svg', '兔南程序员', 1),
    (2, 'top', '/static/demo/banner-2.svg', 'Java 全栈开发', 2),
    (3, 'top', '/static/demo/banner-3.svg', '大数据与人工智能', 3),
    (4, 'index', '/static/demo/online.svg?v=2', '在线课程', 1),
    (5, 'foot', '/static/demo/drive.svg', '驱动教学', 1)
ON DUPLICATE KEY UPDATE
    `position` = VALUES(`position`),
    `img_url` = VALUES(`img_url`),
    `title` = VALUES(`title`),
    `sort_order` = VALUES(`sort_order`);

INSERT INTO `nav_items` (`id`, `title`, `icon`, `course`, `sort_order`) VALUES
    (1, 'Java开发', 'icon-java', 'yes', 1),
    (2, '后端开发', 'icon-houduan', 'yes', 2),
    (3, '自动化测试', 'icon-zidonghua', 'yes', 3),
    (4, '数据分析', 'icon-shujufenxi', 'yes', 4),
    (5, '大数据', 'icon-dashuju', 'yes', 5),
    (6, '人工智能', 'icon-rengongzhineng', 'yes', 6),
    (7, '微服务', 'icon-weifuwu', 'yes', 7),
    (8, '软件测试', 'icon-ruanjianceshi', 'yes', 8),
    (9, '前端开发', 'icon-h', 'yes', 9),
    (10, '更多课程', 'icon-icon--', 'yes', 10)
ON DUPLICATE KEY UPDATE
    `title` = VALUES(`title`),
    `icon` = VALUES(`icon`),
    `course` = VALUES(`course`),
    `sort_order` = VALUES(`sort_order`);

INSERT INTO `specific_courses`
    (`id`, `user_id`, `limit_name`, `teacher_name`, `teacher_job`, `teacher_logo`, `limit_num`, `baoming`, `sort_order`)
VALUES
    (1, 2162, 'Java 入门到就业体验课', '张老师', '· 高级讲师', '/static/demo/teacher-1.svg', 3821, '立即报名', 1),
    (2, 2162, '前端工程化实战体验课', '李老师', '· 前端架构师', '/static/demo/teacher-2.svg', 2956, '立即报名', 2),
    (3, 2162, '人工智能基础体验课', '王老师', '· AI 讲师', '/static/demo/teacher-3.svg', 2188, '立即报名', 3)
ON DUPLICATE KEY UPDATE
    `user_id` = VALUES(`user_id`),
    `limit_name` = VALUES(`limit_name`),
    `teacher_name` = VALUES(`teacher_name`),
    `teacher_job` = VALUES(`teacher_job`),
    `teacher_logo` = VALUES(`teacher_logo`),
    `limit_num` = VALUES(`limit_num`),
    `baoming` = VALUES(`baoming`),
    `sort_order` = VALUES(`sort_order`);

INSERT INTO `courses`
    (`id`, `type`, `text_t`, `description`, `icon`, `colors`, `logo`, `hits`, `sort_order`)
VALUES
    (1, 'employment', 'Java 零基础就业班', '从语法基础到企业级项目', 'icon-java', 'job_scroll_card', '/static/demo/course-java.svg', 12680, 1),
    (2, 'employment', '前端全栈就业班', 'Vue、小程序与工程化实战', 'icon-h', 'job_scroll_card2', '/static/demo/course-web.svg', 9842, 2),
    (3, 'employment', '人工智能就业班', 'Python、机器学习与项目实战', 'icon-rengongzhineng', 'job_scroll_card3', '/static/demo/course-ai.svg', 7615, 3),
    (4, 'recommend', 'Vue 3 企业级项目实战', '组合式 API 与后台管理系统', 'icon-h', '', '/static/demo/recommend-vue.svg', 8654, 1),
    (5, 'recommend', 'MySQL 数据库进阶', '索引、事务、锁与性能优化', 'icon-shujufenxi', '', '/static/demo/recommend-mysql.svg', 7421, 2),
    (6, 'recommend', 'Java 微服务架构', 'Spring Cloud 与分布式基础', 'icon-weifuwu', '', '/static/demo/recommend-cloud.svg', 6893, 3),
    (7, 'recommend', 'Python 自动化测试', '接口、UI 与持续集成', 'icon-zidonghua', '', '/static/demo/recommend-test.svg', 5537, 4)
ON DUPLICATE KEY UPDATE
    `type` = VALUES(`type`),
    `text_t` = VALUES(`text_t`),
    `description` = VALUES(`description`),
    `icon` = VALUES(`icon`),
    `colors` = VALUES(`colors`),
    `logo` = VALUES(`logo`),
    `hits` = VALUES(`hits`),
    `sort_order` = VALUES(`sort_order`);

INSERT INTO `course_details` (`course_id`, `title`, `introduce`, `image`, `height`) VALUES
    (1, 'Java 零基础就业班', '面向零基础学员，系统学习 Java 语法、数据库、Spring Boot 和真实企业项目。', '/static/demo/detail-java.svg', '620'),
    (2, '前端全栈就业班', '覆盖 HTML/CSS、JavaScript、Vue、小程序和前端工程化，完成可展示的实战作品。', '/static/demo/detail-web.svg', '620'),
    (3, '人工智能就业班', '从 Python 基础、数据分析到机器学习和深度学习，逐步建立人工智能工程能力。', '/static/demo/detail-ai.svg', '620'),
    (4, 'Vue 3 企业级项目实战', '使用 Vue 3、Vite、Pinia 和 Element Plus 完成企业级后台管理系统。', '/static/demo/detail-vue.svg', '620'),
    (5, 'MySQL 数据库进阶', '掌握索引设计、事务隔离、锁机制、执行计划与常见性能优化方法。', '/static/demo/detail-mysql.svg', '620')
ON DUPLICATE KEY UPDATE
    `title` = VALUES(`title`),
    `introduce` = VALUES(`introduce`),
    `image` = VALUES(`image`),
    `height` = VALUES(`height`);

INSERT INTO `course_features` (`course_id`, `num`, `txt`, `sort_order`) VALUES
    (1, '680+', '课程课时', 1),
    (1, '42', '实战项目', 2),
    (1, '18', '技术专题', 3),
    (1, '1v1', '就业服务', 4),
    (2, '520+', '课程课时', 1),
    (2, '36', '实战项目', 2),
    (2, '15', '技术专题', 3),
    (2, '1v1', '就业服务', 4),
    (3, '460+', '课程课时', 1),
    (3, '28', '实战项目', 2),
    (3, '12', '技术专题', 3),
    (3, '1v1', '就业服务', 4),
    (4, '128', '课程课时', 1),
    (4, '6', '实战项目', 2),
    (4, '8', '技术专题', 3),
    (4, '长期', '答疑服务', 4),
    (5, '86', '课程课时', 1),
    (5, '5', '实战项目', 2),
    (5, '10', '技术专题', 3),
    (5, '长期', '答疑服务', 4)
ON DUPLICATE KEY UPDATE
    `num` = VALUES(`num`),
    `txt` = VALUES(`txt`);

INSERT INTO `course_chapters` (`course_id`, `type_name`, `sort_order`) VALUES
    (1, '第1章 Java 开发环境与基础语法', 1),
    (1, '第2章 面向对象与常用 API', 2),
    (1, '第3章 MySQL 数据库基础', 3),
    (1, '第4章 Spring Boot 企业开发', 4),
    (1, '第5章 综合项目实战', 5),
    (2, '第1章 HTML、CSS 与响应式布局', 1),
    (2, '第2章 JavaScript 核心进阶', 2),
    (2, '第3章 Vue 3 工程化开发', 3),
    (2, '第4章 微信小程序实战', 4),
    (2, '第5章 前端项目综合实战', 5),
    (3, '第1章 Python 编程基础', 1),
    (3, '第2章 数据分析与可视化', 2),
    (3, '第3章 机器学习基础', 3),
    (3, '第4章 深度学习入门', 4),
    (3, '第5章 人工智能项目实战', 5),
    (4, '第1章 Vue 3 与组合式 API', 1),
    (4, '第2章 Vite 工程化', 2),
    (4, '第3章 Pinia 状态管理', 3),
    (4, '第4章 后台管理系统实战', 4),
    (5, '第1章 索引与执行计划', 1),
    (5, '第2章 事务与锁机制', 2),
    (5, '第3章 SQL 调优实践', 3),
    (5, '第4章 高可用与备份恢复', 4)
ON DUPLICATE KEY UPDATE
    `type_name` = VALUES(`type_name`);
CREATE TABLE IF NOT EXISTS `user_profiles` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `user_id` INT UNSIGNED NOT NULL,
    `nickname` VARCHAR(60) NOT NULL,
    `avatar` VARCHAR(500) NOT NULL DEFAULT '',
    `bio` VARCHAR(160) NOT NULL DEFAULT '',
    `vip_level` VARCHAR(40) NOT NULL DEFAULT '普通学员',
    `study_days` INT UNSIGNED NOT NULL DEFAULT 0,
    `total_hours` DECIMAL(8, 1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_user_profiles_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `user_menus` (
    `id` INT UNSIGNED NOT NULL,
    `title` VARCHAR(60) NOT NULL,
    `icon` VARCHAR(100) NOT NULL,
    `route` VARCHAR(200) NOT NULL DEFAULT '',
    `badge` VARCHAR(20) NOT NULL DEFAULT '',
    `sort_order` INT NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `study_records` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `user_id` INT UNSIGNED NOT NULL,
    `course_id` INT UNSIGNED NOT NULL,
    `progress` TINYINT UNSIGNED NOT NULL DEFAULT 0,
    `learned_lessons` INT UNSIGNED NOT NULL DEFAULT 0,
    `total_lessons` INT UNSIGNED NOT NULL DEFAULT 0,
    `last_study_at` DATETIME NOT NULL,
    `status` ENUM('learning', 'finished') NOT NULL DEFAULT 'learning',
    `sort_order` INT NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_study_user_course` (`user_id`, `course_id`),
    KEY `idx_study_user_sort` (`user_id`, `sort_order`),
    CONSTRAINT `fk_study_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `user_profiles`
    (`id`, `user_id`, `nickname`, `avatar`, `bio`, `vip_level`, `study_days`, `total_hours`)
VALUES
    (1, 2162, '兔南学员', '', '保持热爱，持续学习', 'VIP 会员', 36, 42.5)
ON DUPLICATE KEY UPDATE
    `nickname` = VALUES(`nickname`),
    `avatar` = VALUES(`avatar`),
    `bio` = VALUES(`bio`),
    `vip_level` = VALUES(`vip_level`),
    `study_days` = VALUES(`study_days`),
    `total_hours` = VALUES(`total_hours`);

INSERT INTO `user_menus` (`id`, `title`, `icon`, `route`, `badge`, `sort_order`) VALUES
    (1, '我的订单', 'icon-dingdan', '', '', 1),
    (2, '我的收藏', 'icon-shoucang', '', '', 2),
    (3, '学习记录', 'icon-xuexi', '', '3', 3),
    (4, '优惠券', 'icon-youhuiquan', '', '2', 4),
    (5, '设置', 'icon-shezhi', '', '', 5)
ON DUPLICATE KEY UPDATE
    `title` = VALUES(`title`),
    `icon` = VALUES(`icon`),
    `route` = VALUES(`route`),
    `badge` = VALUES(`badge`),
    `sort_order` = VALUES(`sort_order`);

INSERT INTO `study_records`
    (`id`, `user_id`, `course_id`, `progress`, `learned_lessons`, `total_lessons`, `last_study_at`, `status`, `sort_order`)
VALUES
    (1, 2162, 1, 68, 34, 50, '2026-10-04 19:30:00', 'learning', 1),
    (2, 2162, 4, 45, 18, 40, '2026-10-03 21:15:00', 'learning', 2),
    (3, 2162, 5, 83, 25, 30, '2026-10-02 20:40:00', 'learning', 3),
    (4, 2162, 2, 100, 42, 42, '2026-09-28 18:20:00', 'finished', 4)
ON DUPLICATE KEY UPDATE
    `progress` = VALUES(`progress`),
    `learned_lessons` = VALUES(`learned_lessons`),
    `total_lessons` = VALUES(`total_lessons`),
    `last_study_at` = VALUES(`last_study_at`),
    `status` = VALUES(`status`),
    `sort_order` = VALUES(`sort_order`);