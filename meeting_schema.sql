-- 회의록 테이블
CREATE TABLE IF NOT EXISTS meetings (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid DEFAULT '00000000-0000-0000-0000-000000000000',
    task_id text,                  -- 연결된 할일(tasks.id), 독립 작성 시 null
    title text NOT NULL,
    meeting_date text NOT NULL,    -- YYYY-MM-DD
    location text,
    attendees text,                -- 쉼표로 구분한 참석자 목록
    agenda text,                   -- 안건/논의내용
    decisions text,                -- 결정사항
    created_at timestamp DEFAULT now(),
    updated_at timestamp DEFAULT now()
);

-- 액션 아이템 테이블
CREATE TABLE IF NOT EXISTS meeting_actions (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    meeting_id uuid REFERENCES meetings(id) ON DELETE CASCADE,
    content text NOT NULL,
    assignee text,
    due_date text,                 -- YYYY-MM-DD
    completed boolean DEFAULT false,
    linked_task_id text,           -- tasks 테이블에 자동 생성된 할일 id
    created_at timestamp DEFAULT now()
);

-- RLS 비활성화 (개발 중)
ALTER TABLE meetings DISABLE ROW LEVEL SECURITY;
ALTER TABLE meeting_actions DISABLE ROW LEVEL SECURITY;
