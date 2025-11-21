--
-- Archivo generado con SQLiteStudio v3.4.17 el vi. nov. 21 15:45:49 2025
--
-- Codificación de texto usada: System
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Tabla: Artist
CREATE TABLE IF NOT EXISTS Artist (
  artistID            INTEGER         PRIMARY KEY,
  personID            INTEGER         NOT NULL UNIQUE,
  style               TEXT,
  description         TEXT,
  FOREIGN KEY (personID) REFERENCES Person(personID)
);

-- Tabla: ArtRoom
CREATE TABLE IF NOT EXISTS ArtRoom (
  roomID              INTEGER         PRIMARY KEY,
  capacity            INTEGER         NOT NULL CHECK (capacity > 0),
  sectionID           INTEGER         NOT NULL,
  FOREIGN KEY (roomID)   REFERENCES Room(roomID),
  FOREIGN KEY (sectionID) REFERENCES Section(sectionID)
);

-- Tabla: ArtWork
CREATE TABLE IF NOT EXISTS ArtWork (
  pieceID             INTEGER         PRIMARY KEY,
  title               TEXT            NOT NULL,
  description         TEXT,
  type                TEXT,
  state               TEXT            NOT NULL CHECK (state IN ('InUse','Maintenance','Stored')),
  artistID            INTEGER         NOT NULL,
  warehouseID         INTEGER,
  roomID              INTEGER,
  FOREIGN KEY (artistID)    REFERENCES Artist(artistID),
  FOREIGN KEY (warehouseID) REFERENCES Warehouse(warehouseID),
  FOREIGN KEY (roomID)      REFERENCES Room(roomID),
  CHECK ((roomID IS NULL) <> (warehouseID IS NULL)),
  CHECK (
    (state = 'InUse' AND roomID IS NOT NULL AND warehouseID IS NULL) OR
    (state <> 'InUse' AND roomID IS NULL AND warehouseID IS NOT NULL)
  )
);

-- Tabla: Event
CREATE TABLE IF NOT EXISTS Event (
  eventID             INTEGER         PRIMARY KEY,
  theme               TEXT            NOT NULL UNIQUE,
  startDate           DATE,
  endDate             DATE,
  CHECK (endDate IS NULL OR startDate < endDate)
);

-- Tabla: Experience
CREATE TABLE IF NOT EXISTS Experience (
  visitID            INTEGER         NOT NULL,
  packID             INTEGER         NOT NULL,
  feedbackID         INTEGER         NOT NULL,
  eventID            INTEGER         NOT NULL,
  PRIMARY KEY (visitID, packID),
  FOREIGN KEY (visitID)    REFERENCES Visit(visitID),
  FOREIGN KEY (packID)     REFERENCES VisitPack(packID),
  FOREIGN KEY (feedbackID) REFERENCES Feedback(feedbackID),
  FOREIGN KEY (eventID)    REFERENCES Event(eventID)
);

-- Tabla: Favourite
CREATE TABLE IF NOT EXISTS Favourite (
  feedbackID         INTEGER         NOT NULL,
  pieceID            INTEGER         NOT NULL,
  PRIMARY KEY (feedbackID, pieceID),
  FOREIGN KEY (feedbackID) REFERENCES Feedback(feedbackID),
  FOREIGN KEY (pieceID)    REFERENCES ArtWork(pieceID)
);

-- Tabla: Feedback
CREATE TABLE IF NOT EXISTS Feedback (
  feedbackID          INTEGER         PRIMARY KEY,
  packRating          INTEGER,
  opinion             TEXT,
  suggestions         TEXT
);

-- Tabla: Office
CREATE TABLE IF NOT EXISTS Office (
  roomID              INTEGER         PRIMARY KEY,
  n_Computers         INTEGER,
  FOREIGN KEY (roomID) REFERENCES Room(roomID)
);

-- Tabla: Person
CREATE TABLE IF NOT EXISTS Person (
  personID            INTEGER         PRIMARY KEY,
  name                TEXT            NOT NULL,
  birthDate           DATE,
  nationality         TEXT,
  gender              TEXT
);

-- Tabla: Room
CREATE TABLE IF NOT EXISTS Room (
  roomID              INTEGER         PRIMARY KEY,
  roomNumber          TEXT            NOT NULL,
  floor               INTEGER         NOT NULL
);

-- Tabla: Section
CREATE TABLE IF NOT EXISTS Section (
  sectionID           INTEGER         PRIMARY KEY,
  eventID             INTEGER         NOT NULL,
  FOREIGN KEY (eventID) REFERENCES Event(eventID)
);

-- Tabla: Staff
CREATE TABLE IF NOT EXISTS Staff (
  staffID             INTEGER         PRIMARY KEY,
  personID            INTEGER         NOT NULL UNIQUE,
  salary              REAL            NOT NULL CHECK (salary > 0),
  contractStart       DATE,
  contractEnd         DATE,
  curriculumVitae     TEXT,
  FOREIGN KEY (personID) REFERENCES Person(personID),
  CHECK (contractEnd IS NULL OR contractStart < contractEnd)
);

-- Tabla: StaffRoomNumber
CREATE TABLE IF NOT EXISTS StaffRoomNumber (
  staffID            INTEGER         NOT NULL,
  roomID             INTEGER         NOT NULL,
  PRIMARY KEY (staffID, roomID),
  FOREIGN KEY (staffID) REFERENCES Staff(staffID),
  FOREIGN KEY (roomID)  REFERENCES Room(roomID)
);

-- Tabla: Task
CREATE TABLE IF NOT EXISTS Task (
  staffID            INTEGER         NOT NULL,
  roomID             INTEGER         NOT NULL,
  name               TEXT            NOT NULL,
  date               TEXT            NOT NULL,
  description        TEXT,
  PRIMARY KEY (staffID, roomID),
  FOREIGN KEY (staffID) REFERENCES Staff(staffID),
  FOREIGN KEY (roomID)  REFERENCES Room(roomID)
);

-- Tabla: Visit
CREATE TABLE IF NOT EXISTS Visit (
  visitID             INTEGER         PRIMARY KEY,
  visitDate           DATE,
  partySize           INTEGER,
  discount            REAL,
  personID            INTEGER         NOT NULL UNIQUE,
  FOREIGN KEY (personID) REFERENCES Visitor(personID)
);

-- Tabla: Visitor
CREATE TABLE IF NOT EXISTS Visitor (
  visitorID           INTEGER         PRIMARY KEY,
  personID            INTEGER         NOT NULL UNIQUE,
  email               TEXT            NOT NULL UNIQUE,
  phoneNumber         Integer         NOT NULL UNIQUE,
  FOREIGN KEY (personID) REFERENCES Person(personID)
);

-- Tabla: VisitPack
CREATE TABLE IF NOT EXISTS VisitPack (
  packID              INTEGER         PRIMARY KEY,
  name                TEXT            NOT NULL,
  purchaseDate        DATE,
  price               REAL,
  description         TEXT
);

-- Tabla: Warehouse
CREATE TABLE IF NOT EXISTS Warehouse (
  warehouseID         INTEGER         PRIMARY KEY,
  location            TEXT,
  storage             TEXT
);

COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
