DROP TABLE IF EXISTS member CASCADE;
DROP TABLE IF EXISTS enemy CASCADE;
DROP TABLE IF EXISTS person CASCADE;
DROP TABLE IF EXISTS asset CASCADE;
DROP TABLE IF EXISTS linking CASCADE;
DROP TABLE IF EXISTS participate CASCADE;
DROP TABLE IF EXISTS role CASCADE;
DROP TABLE IF EXISTS serve CASCADE;
DROP TABLE IF EXISTS party CASCADE;
DROP TABLE IF EXISTS ally CASCADE;
DROP TABLE IF EXISTS value CASCADE;
DROP TABLE IF EXISTS affiliates CASCADE;
DROP TABLE IF EXISTS supports CASCADE;
DROP TABLE IF EXISTS sponsor CASCADE;
DROP TABLE IF EXISTS grant_ CASCADE;
DROP TABLE IF EXISTS opponent CASCADE;
DROP TABLE IF EXISTS oppose CASCADE;

CREATE TABLE member (
    id INT PRIMARY KEY,
    startDate DATE NOT NULL
);

CREATE TABLE enemy (
    id INT PRIMARY KEY,
    reason VARCHAR NOT NULL,

    -- Categorization of opponent
    opponentId INT REFERENCES opponent(id) NOT NULL
);

CREATE TABLE person (
    id INT PRIMARY KEY,
    name VARCHAR NOT NULL,
    address VARCHAR NOT NULL,
    phone VARCHAR NOT NULL,
    birthDate DATE NOT NULL,
    deathDate DATE,

    -- Total overlapping specialization
    memberId INT REFERENCES member(id), -- NULL means not a member
    enemyId INT REFERENCES enemy(id) -- NULL means not an enemy
);

-- 1 member has 0..* asset
CREATE TABLE asset (
    name VARCHAR PRIMARY KEY,
    ownerId INT REFERENCES person(id) NOT NULL,
    detail VARCHAR NOT NULL,
    uses VARCHAR NOT NULL
);

CREATE TABLE linking (
    id INT PRIMARY KEY,
    name VARCHAR NOT NULL,
    type_ VARCHAR NOT NULL,
    description VARCHAR NOT NULL
);

-- 1..* person participates in 0..* linking
CREATE TABLE participate (
    personId INT REFERENCES person(id) NOT NULL,
    linkingId INT REFERENCES linking(id) NOT NULL,
    PRIMARY KEY (personId, linkingId),

    monitorId INT REFERENCES member(id) NOT NULL -- 1 member monitors 0..* participation
);

CREATE TABLE role (
    id INT PRIMARY KEY,
    title VARCHAR UNIQUE NOT NULL,
    salary INT NOT NULL
);

-- 0..* member serves in 0..* role
CREATE TABLE serve (
    memberId INT REFERENCES member(id) NOT NULL,
    roleId INT REFERENCES role(id) NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,

    PRIMARY KEY (memberId, roleId)
);

CREATE TABLE party (
    id INT PRIMARY KEY,
    country VARCHAR NOT NULL,
    name VARCHAR NOT NULL,
    UNIQUE (country, name), -- Country + name must be unique

    -- Monitors relation
    memberId INT REFERENCES member(id) NOT NULL, -- 1 member monitors 0..* party
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    log_ VARCHAR NOT NULL,

    -- Categorization of opponent
    opponentId INT REFERENCES opponent(id) NOT NULL
);

CREATE TABLE ally (
    alias VARCHAR PRIMARY KEY,
    trust SMALLINT NOT NULL
);

-- 1 ally has 0..* value
CREATE TABLE value (
    id INT PRIMARY KEY,
    allyAlias VARCHAR REFERENCES ally(alias) not null
);

-- 1..* member affiliates 0..* ally
CREATE TABLE affiliates (
    memberId INT REFERENCES member(id) NOT NULL,
    allyAlias VARCHAR REFERENCES ally(alias) NOT NULL,

    PRIMARY KEY (memberId, allyAlias)
);

-- 0..* ally supports 0..* party
CREATE TABLE supports (
    allyAlias VARCHAR REFERENCES ally(alias) NOT NULL,
    partyId INT REFERENCES party(id) NOT NULL,
    
    PRIMARY KEY (allyAlias, partyId)
);

CREATE TABLE sponsor (
    id INT PRIMARY KEY,
    name VARCHAR NOT NULL,
    address VARCHAR NOT NULL,
    industry VARCHAR NOT NULL
);

-- 0..* sponsor grants 0..* member
CREATE TABLE grant_ (
    sponsorId INT REFERENCES sponsor(id) NOT NULL,
    memberId INT REFERENCES member(id) NOT NULL,
    date_ DATE NOT NULL,
    amount INT NOT NULL,
    payback VARCHAR NOT NULL,

    PRIMARY KEY (sponsorId, memberId, date_),

    -- 0..1 member review 0..* grant
    reviewerId INT REFERENCES member(id),
    reviewDate DATE,
    reviewGrade SMALLINT
);

CREATE TABLE opponent (
    id INT PRIMARY KEY
);

-- 0..* member opposes 0..* opponent
CREATE TABLE oppose (
    memberId INT REFERENCES member(id) NOT NULL,
    opponentId INT REFERENCES opponent(id) NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE,

    PRIMARY KEY (memberId, opponentId)
);

