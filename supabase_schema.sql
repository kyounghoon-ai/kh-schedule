-- Personal Task Management System - Supabase Schema

-- 1. Schedules 테이블 (업무 일정)
CREATE TABLE IF NOT EXISTS schedules (
  id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id uuid DEFAULT auth.uid() NOT NULL,
  title text NOT NULL,
  description text,
  date text NOT NULL, -- YYYY-MM-DD format
  start_time text, -- HH:mm format
  end_time text,
  category text NOT NULL, -- 'work', 'personal', 'team'
  team_shared boolean DEFAULT false, -- 팀 캘린더에 공유할지 여부
  team_id uuid, -- 팀 ID (나중에 추가)
  created_at timestamp DEFAULT now(),
  updated_at timestamp DEFAULT now(),
  
  CONSTRAINT valid_category CHECK (category IN ('work', 'personal', 'team'))
);

-- 2. Tasks 테이블 (투두 리스트)
CREATE TABLE IF NOT EXISTS tasks (
  id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id uuid DEFAULT auth.uid() NOT NULL,
  title text NOT NULL,
  description text,
  date text NOT NULL, -- YYYY-MM-DD format
  category text NOT NULL, -- 'work', 'personal', 'team'
  priority text DEFAULT 'medium', -- 'low', 'medium', 'high'
  completed boolean DEFAULT false,
  due_date text, -- YYYY-MM-DD format (선택)
  created_at timestamp DEFAULT now(),
  updated_at timestamp DEFAULT now(),
  
  CONSTRAINT valid_category CHECK (category IN ('work', 'personal', 'team')),
  CONSTRAINT valid_priority CHECK (priority IN ('low', 'medium', 'high'))
);

-- 3. Weekly Reports 테이블 (나중에 추가)
CREATE TABLE IF NOT EXISTS weekly_reports (
  id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id uuid DEFAULT auth.uid() NOT NULL,
  week_start text NOT NULL, -- YYYY-MM-DD format
  week_end text NOT NULL,
  total_tasks integer,
  completed_tasks integer,
  completion_rate numeric,
  work_summary text,
  personal_summary text,
  notes text,
  created_at timestamp DEFAULT now(),
  updated_at timestamp DEFAULT now()
);

-- 4. User Settings 테이블 (나중에 추가)
CREATE TABLE IF NOT EXISTS user_settings (
  id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id uuid DEFAULT auth.uid() NOT NULL UNIQUE,
  notification_enabled boolean DEFAULT true,
  notification_time text DEFAULT '09:00', -- HH:mm
  reminder_days_before integer DEFAULT 1, -- 마감 며칠 전 알림
  email_enabled boolean DEFAULT true,
  theme text DEFAULT 'light',
  created_at timestamp DEFAULT now(),
  updated_at timestamp DEFAULT now()
);

-- RLS (Row Level Security) 정책 설정

-- Schedules RLS
ALTER TABLE schedules ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own schedules"
  ON schedules FOR SELECT
  USING (auth.uid() = user_id OR team_shared = true);

CREATE POLICY "Users can insert their own schedules"
  ON schedules FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own schedules"
  ON schedules FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own schedules"
  ON schedules FOR DELETE
  USING (auth.uid() = user_id);

-- Tasks RLS
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own tasks"
  ON tasks FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own tasks"
  ON tasks FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own tasks"
  ON tasks FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own tasks"
  ON tasks FOR DELETE
  USING (auth.uid() = user_id);

-- Weekly Reports RLS
ALTER TABLE weekly_reports ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own reports"
  ON weekly_reports FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own reports"
  ON weekly_reports FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own reports"
  ON weekly_reports FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- User Settings RLS
ALTER TABLE user_settings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own settings"
  ON user_settings FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can update their own settings"
  ON user_settings FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- 인덱스 추가 (성능 최적화)
CREATE INDEX idx_schedules_user_date ON schedules(user_id, date);
CREATE INDEX idx_schedules_team_shared ON schedules(team_shared);
CREATE INDEX idx_tasks_user_date ON tasks(user_id, date);
CREATE INDEX idx_tasks_user_completed ON tasks(user_id, completed);
CREATE INDEX idx_weekly_reports_user_week ON weekly_reports(user_id, week_start);
CREATE INDEX idx_user_settings_user_id ON user_settings(user_id);
