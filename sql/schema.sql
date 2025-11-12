-- 期刊分析系统数据库架构

-- 期刊基本信息表
CREATE TABLE IF NOT EXISTS journals (
    journal_id VARCHAR(50) PRIMARY KEY,
    journal_name VARCHAR(200) NOT NULL,
    country VARCHAR(50), -- 'domestic' or 'international'
    field VARCHAR(100), -- 学科领域
    publisher VARCHAR(200),
    established_year INTEGER
);

-- 论文基本信息表
CREATE TABLE IF NOT EXISTS papers (
    paper_id VARCHAR(50) PRIMARY KEY,
    journal_id VARCHAR(50) REFERENCES journals(journal_id),
    year INTEGER NOT NULL,
    title TEXT NOT NULL,
    abstract TEXT,
    citation_count INTEGER DEFAULT 0,
    reference_count INTEGER DEFAULT 0,
    author_count INTEGER DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 关键词表
CREATE TABLE IF NOT EXISTS keywords (
    keyword_id SERIAL PRIMARY KEY,
    paper_id VARCHAR(50) REFERENCES papers(paper_id),
    keyword VARCHAR(200) NOT NULL,
    keyword_type VARCHAR(50), -- 'author', 'extracted'
    UNIQUE(paper_id, keyword)
);

-- 主题分类表
CREATE TABLE IF NOT EXISTS topics (
    topic_id SERIAL PRIMARY KEY,
    paper_id VARCHAR(50) REFERENCES papers(paper_id),
    topic_label VARCHAR(200) NOT NULL,
    topic_probability FLOAT,
    classification_method VARCHAR(50) -- 'lda', 'llm', 'manual'
);

-- 研究方法表
CREATE TABLE IF NOT EXISTS methodologies (
    method_id SERIAL PRIMARY KEY,
    paper_id VARCHAR(50) REFERENCES papers(paper_id),
    method_label VARCHAR(200) NOT NULL,
    method_type VARCHAR(100), -- 'experimental', 'computational', etc.
    confidence_score FLOAT
);

-- 引文网络表
CREATE TABLE IF NOT EXISTS citations (
    citation_id SERIAL PRIMARY KEY,
    citing_paper_id VARCHAR(50) REFERENCES papers(paper_id),
    cited_paper_id VARCHAR(50) REFERENCES papers(paper_id),
    citation_context TEXT
);

-- 指标结果表
CREATE TABLE IF NOT EXISTS journal_metrics (
    metric_id SERIAL PRIMARY KEY,
    journal_id VARCHAR(50) REFERENCES journals(journal_id),
    year INTEGER,
    metric_name VARCHAR(100) NOT NULL, -- 'topic_entropy', 'novelty_score', etc.
    metric_value FLOAT NOT NULL,
    calculation_method VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建索引以提高查询性能
CREATE INDEX IF NOT EXISTS idx_papers_journal_year ON papers(journal_id, year);
CREATE INDEX IF NOT EXISTS idx_keywords_paper ON keywords(paper_id);
CREATE INDEX IF NOT EXISTS idx_topics_paper ON topics(paper_id);
CREATE INDEX IF NOT EXISTS idx_metrics_journal_year ON journal_metrics(journal_id, year);