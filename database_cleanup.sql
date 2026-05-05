-- ============================================================
-- VMMS 数据库整理脚本
-- 生成日期: 2026-05-05
-- 说明: 清理无用表，保留核心业务数据
-- ============================================================

-- 【注意】执行前请先备份数据库！
-- mysqldump -u root -p vmms > vmms_backup_20260505.sql

USE vmms;

-- ============================================================
-- 第一部分: 删除无用表
-- ============================================================

-- 1. 删除 arrears 表 (欠款表)
-- 原因: 该表在代码中仅有 Mapper 定义，无任何 Service 或 Controller 调用
-- 欠款功能可通过 balancesheet 表的 payment_status 字段实现
DROP TABLE IF EXISTS arrears;

-- 2. 删除 materhis 表 (材料消耗历史表)
-- 原因: 该表在代码中仅有 Mapper 定义，无任何 Service 或 Controller 调用
-- 材料消耗记录功能已由 partused + accessoryhis 表覆盖
DROP TABLE IF EXISTS materhis;

-- ============================================================
-- 第二部分: 清理测试数据
-- ============================================================

-- 检查并清理可能的测试数据（仅清理明显为测试的记录）
-- 注意: bustatus 和 paystatus 的初始化数据属于必要基础数据，请勿删除

-- 清理测试客户数据（如果存在含"测试"/"test"关键字的记录）
-- 【请根据实际数据情况决定是否执行】
-- DELETE FROM customervisithis WHERE customername LIKE '%测试%' OR customername LIKE '%test%';
-- DELETE FROM orders WHERE id IN (
--     SELECT id FROM customer WHERE numbering LIKE '%测试%' OR numbering LIKE '%test%'
-- );

-- 清理系统操作日志中30天前的旧记录（可选）
-- DELETE FROM operation_log WHERE operation_time < DATE_SUB(NOW(), INTERVAL 30 DAY);

-- ============================================================
-- 第三部分: 优化建议（需手动确认后执行）
-- ============================================================

-- 1. 为常用查询字段添加索引
-- ALTER TABLE orders ADD INDEX idx_customerid (customerid);
-- ALTER TABLE orders ADD INDEX idx_vehicleid (vehicleid);
-- ALTER TABLE orders ADD INDEX idx_bustatusid (bustatusid);
-- ALTER TABLE vehicle ADD INDEX idx_customerid (customerid);
-- ALTER TABLE partused ADD INDEX idx_ordersid (ordersid);
-- ALTER TABLE mainprojreg ADD INDEX idx_ordersid (ordersid);

-- 2. 优化表空间
-- OPTIMIZE TABLE orders, customer, vehicle, part, partused, mainprojreg;

-- ============================================================
-- 执行完成
-- ============================================================
SELECT '数据库整理完成 - 已删除表: arrears, materhis' AS result;
