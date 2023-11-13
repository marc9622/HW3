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
DROP TABLE IF EXISTS grantMoney CASCADE;

CREATE TABLE member (
    id INT PRIMARY KEY,
    startDate DATE NOT NULL
);

CREATE TABLE enemy (
    id INT PRIMARY KEY,
    reason VARCHAR NOT NULL
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

CREATE TABLE asset (
    name VARCHAR PRIMARY KEY,
    memberId INT REFERENCES person(id) NOT NULL, -- 1 member has 0..* asset
    detail VARCHAR NOT NULL,
    uses VARCHAR NOT NULL
);

CREATE TABLE linking (
    id INT PRIMARY KEY,
    name VARCHAR NOT NULL,
    type VARCHAR NOT NULL,
    description VARCHAR NOT NULL
);

-- 1..* person participates in 0..* linking
CREATE TABLE participate (
    personId INT REFERENCES person(id) NOT NULL,
    linkingId INT REFERENCES linking(id) NOT NULL,
    PRIMARY KEY (personId, linkingId),

    memberId INT REFERENCES member(id) NOT NULL -- 1 member monitors 0..* participation
);

CREATE TABLE role (
    id INT PRIMARY KEY,
    title VARCHAR NOT NULL,
    salary INT NOT NULL
);

-- 0..* member serves in 0..* role
CREATE TABLE serve (
    memberId INT REFERENCES member(id) NOT NULL,
    roleId INT REFERENCES role(id) NOT NULL,
    PRIMARY KEY (memberId, roleId),

    startDate DATE NOT NULL,
    endDate DATE NOT NULL
);

CREATE TABLE party (
    id INT PRIMARY KEY,
    country VARCHAR NOT NULL,
    name VARCHAR NOT NULL,

    -- Monitors relation
    memberId INT REFERENCES member(id) NOT NULL, -- 1 member monitors 0..* party
    startDate DATE NOT NULL,
    endDate DATE NOT NULL
);

CREATE TABLE ally (
    alias VARCHAR PRIMARY KEY,
    trustLevel SMALLINT NOT NULL
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
CREATE TABLE grantMoney (
    sponsorId INT REFERENCES sponsor(id) NOT NULL,
    memberId INT REFERENCES member(id) NOT NULL,
    PRIMARY KEY (sponsorId, memberId),

    grantDate DATE NOT NULL,
    amount INT NOT NULL,
    payback VARCHAR NOT NULL
);

