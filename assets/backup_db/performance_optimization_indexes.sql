-- Performance Optimization: Add Missing Indexes
-- This migration adds critical indexes to improve login performance
-- Execute this SQL on your database to apply the optimizations

-- ============================================================================
-- CRITICAL: Add index on users.email for faster login queries
-- Without this index, every login does a full table scan
-- ============================================================================
ALTER TABLE `users`
ADD INDEX `idx_email` (`email`),
ADD INDEX `idx_email_password_deleted_status` (`email`, `password`, `deleted`, `status`);

-- ============================================================================
-- Add composite index on facebook_rx_fb_page_info for faster page lookups
-- This prevents full table scans when checking if pages already exist
-- ============================================================================
ALTER TABLE `facebook_rx_fb_page_info`
ADD INDEX `idx_user_page` (`facebook_rx_fb_user_info_id`, `page_id`);

-- ============================================================================
-- Add composite index on facebook_rx_config for faster config lookups
-- This prevents full table scans when fetching available FB configs
-- ============================================================================
ALTER TABLE `facebook_rx_config`
ADD INDEX `idx_status_use_developer` (`status`, `use_by`, `developer_access`);

-- ============================================================================
-- Add index on facebook_rx_fb_user_info for faster user lookups
-- ============================================================================
ALTER TABLE `facebook_rx_fb_user_info`
ADD INDEX `idx_user_id` (`user_id`);

-- ============================================================================
-- Add index on google_user_account if table exists (for GMB addon)
-- ============================================================================
-- Uncomment if you have the GMB addon installed:
-- ALTER TABLE `google_user_account`
-- ADD INDEX `idx_user_id` (`user_id`);

-- ============================================================================
-- PERFORMANCE NOTES:
-- - These indexes will significantly speed up login queries
-- - The users.email index is the most critical one
-- - Apply during low-traffic periods if you have a large database
-- - Index creation time depends on table size (should be quick for most cases)
-- ============================================================================
