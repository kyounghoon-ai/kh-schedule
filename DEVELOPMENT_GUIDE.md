# 개인 업무 관리 시스템 - 개발 가이드

## 📁 프로젝트 구조

```
personal-scheduler/
├── index.html              # 메인 앱 (현재 제공)
├── supabase_schema.sql     # DB 스키마
├── README.md               # (이 파일)
└── (나중에 추가할 파일들)
  ├── styles/
  ├── scripts/
  ├── components/
  └── ...
```

---

## 🚀 빠른 시작

### 1️⃣ Supabase 설정

#### Step 1: Supabase 프로젝트 생성
1. [supabase.com](https://supabase.com) 접속
2. 새 프로젝트 생성
3. Project URL과 Anon Key 복사

#### Step 2: 데이터베이스 스키마 생성
1. Supabase 대시보드 → SQL Editor
2. `supabase_schema.sql` 파일 내용 전체 복사 및 실행
3. 테이블 생성 완료 확인

#### Step 3: 인증 설정
1. Authentication → Providers → Email 활성화
2. 또는 Google/GitHub OAuth 설정

---

### 2️⃣ HTML 파일 설정

#### Step 1: 환경 변수 설정
`personal_scheduler.html` 파일에서 다음 부분 수정:

```javascript
// Supabase 초기화
const SUPABASE_URL = 'YOUR_SUPABASE_URL';  // 👈 여기에 Project URL 붙여넣기
const SUPABASE_KEY = 'YOUR_SUPABASE_ANON_KEY';  // 👈 여기에 Anon Key 붙여넣기
```

**예시:**
```javascript
const SUPABASE_URL = 'https://abcdefgh.supabase.co';
const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
```

#### Step 2: 로컬에서 테스트
- `personal_scheduler.html`을 브라우저에서 열기
- 또는 로컬 서버 실행:
  ```bash
  python -m http.server 8000
  # 브라우저에서 http://localhost:8000/personal_scheduler.html 접속
  ```

#### Step 3: Vercel에 배포
1. GitHub 레포 생성 및 파일 Push
2. [vercel.com](https://vercel.com)에서 Import
3. 환경 변수 설정:
   ```
   SUPABASE_URL = your_url
   SUPABASE_KEY = your_key
   ```
4. Deploy

---

## 🎯 현재 구현된 기능

✅ **완료**
- 주간 캘린더 뷰 (월/화/수/목/금/토/일)
- 일정 추가 (날짜 선택)
- 투두 리스트 (추가, 완료, 삭제)
- 카테고리 필터링 (업무/개인/팀연동)
- 색상 코드 (파란색=업무, 초록색=개인, 분홍색=팀)
- 로컬 스토리지 저장 (Supabase 연동 전까지)
- Supabase 기본 CRUD 구조

---

## 📋 다음 단계 (TODO)

### Phase 1: 기본 기능 보강
- [ ] 월간 캘린더 뷰 추가
- [ ] 일정/투두 편집 기능
- [ ] 시간대별 일정 추가 (start_time, end_time)
- [ ] 우선순위 표시 (high/medium/low)
- [ ] 마감일(due_date) 표시

### Phase 2: 팀 연동
- [ ] `team_shared` 토글 기능
- [ ] 상품기획팀 캘린더와의 동기화
- [ ] Edge Function으로 자동 동기
- [ ] 팀 일정에 2px 테두리 표시

### Phase 3: 자동화
- [ ] 주간 리포트 자동 생성
- [ ] 이메일 리마인더 (Resend)
- [ ] 마감 임박 알림
- [ ] pg_cron으로 스케줄 작업

### Phase 4: 고급 기능
- [ ] 반복 일정 (매일, 매주 등)
- [ ] 태그/라벨 관리
- [ ] 시간 추적
- [ ] 검색 기능
- [ ] Google Calendar 동기화
- [ ] Excel 내보내기

---

## 🔧 주요 함수 설명

### 데이터 로드
```javascript
loadSchedules()  // Supabase에서 일정 로드
loadTasks()      // Supabase에서 투두 로드
```

### 렌더링
```javascript
renderWeek()     // 주간 캘린더 렌더링
renderTasks()    // 투두 리스트 렌더링
updateSelectedDateDisplay()  // 선택된 날짜 표시 업데이트
```

### 데이터 조작
```javascript
addQuickTask()      // 빠른 투두 추가
toggleTask()        // 투두 완료/미완료
deleteTask()        // 투두 삭제
selectDate()        // 날짜 선택
```

### 필터링
```javascript
filterByCategory()  // 카테고리별 필터링
```

---

## 🗂️ 데이터 스키마

### schedules 테이블
```sql
id (UUID)           -- 고유 ID
user_id (UUID)      -- 사용자 ID
title (text)        -- 일정 제목
description (text)  -- 설명 (선택)
date (text)         -- 날짜 (YYYY-MM-DD)
start_time (text)   -- 시작 시간 (HH:mm)
end_time (text)     -- 종료 시간 (HH:mm)
category (text)     -- 'work' / 'personal' / 'team'
team_shared (bool)  -- 팀 공유 여부
team_id (UUID)      -- 팀 ID (나중에)
created_at (ts)     -- 생성 시간
updated_at (ts)     -- 수정 시간
```

### tasks 테이블
```sql
id (UUID)           -- 고유 ID
user_id (UUID)      -- 사용자 ID
title (text)        -- 투두 제목
description (text)  -- 설명 (선택)
date (text)         -- 날짜 (YYYY-MM-DD)
category (text)     -- 'work' / 'personal' / 'team'
priority (text)     -- 'low' / 'medium' / 'high'
completed (bool)    -- 완료 여부
due_date (text)     -- 마감일 (YYYY-MM-DD)
created_at (ts)     -- 생성 시간
updated_at (ts)     -- 수정 시간
```

---

## 🔐 RLS (Row Level Security) 정책

- ✅ 사용자는 자신의 데이터만 볼 수 있음
- ✅ 다른 사용자 데이터는 접근 불가
- ✅ `team_shared = true`인 일정은 팀원이 볼 수 있음 (나중에 구현)

---

## 🐛 트러블슈팅

### "Supabase 연동이 안 됨"
→ SUPABASE_URL과 SUPABASE_KEY가 올바른지 확인
→ 브라우저 개발자 도구 → Console에서 에러 확인

### "로컬 스토리지는 보이는데 Supabase에 안 저장됨"
→ 사용자 인증이 필요함 (auth.uid()가 설정되어야 함)
→ Supabase 대시보드 → Authentication에서 테스트 사용자 추가

### "테이블이 없다는 에러"
→ `supabase_schema.sql`을 SQL Editor에서 실행했는지 확인
→ 테이블 목록 새로고침

---

## 📝 코드 커스터마이징 팁

### 색상 변경
```css
/* HTML의 <style> 섹션에서 수정 */
.color-work { background-color: #3B8BD4; }
.color-personal { background-color: #639922; }
.color-team { background-color: #D4537E; }
```

### 카테고리 추가
```javascript
// getCategoryLabel() 함수에 추가
const labels = { 
  work: '업무', 
  personal: '개인', 
  team: '팀연동',
  meeting: '회의'  // 👈 새 카테고리
};
```

### 필터 버튼 추가
```html
<!-- HTML의 filter-buttons 섹션에 추가 -->
<button class="filter-btn" onclick="filterByCategory('meeting')">회의</button>
```

---

## 🎨 UI 커스터마이징

현재 레이아웃:
- 좌측 60% : 캘린더
- 우측 40% : 투두 리스트

레이아웃 변경하려면:
```css
.main-layout {
    grid-template-columns: 1.3fr 1fr;  /* 👈 비율 조정 */
    gap: 20px;
}
```

---

## 📞 질문 & 피드백

구현하면서 문제가 생기면:
1. 먼저 브라우저 Console 에러 확인
2. Supabase 대시보드에서 데이터 확인
3. 필요하면 파일 수정 후 재배포

---

## 🎯 전체 로드맵

```
Week 1: 기본 CRUD + UI
Week 2: 팀 연동 + 동기화
Week 3: 자동화 (리포트, 이메일)
Week 4: 고급 기능 (반복, 검색 등)
```

행운을 빕니다! 🚀
