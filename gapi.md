Some Notes
=====
* Passwords are a weird scheme whereby the following occurs:
  *  `S_START_STREAM` is sent upon the client connection, which includes a salt for hashing.
  *  The client:
     *  Hashes the login password w/ MD5
     *  Prepends the salt to this hash (i.e. `[SALT][HASH]`)
     *  Hashes the prepended string with SHA-1
     *  Sends this back w/ the client login request

Known Packets
======

## **Clientbound (S->C)**
### **0x1B5A - `S_LOGIN`**

Sent in response to a client's login request, validating whether or not
the client should proceed with login procedures.

Codes seem to be divided as follows:

| Code | Name                      | Description                  |
| ---- | ------------------------- | ---------------------------- |
| 0x00 | LOGIN_OK                  | Login good - proceed         |
| 0x01 | LOGIN_BAD_PASS            | Bad Password                 |
| 0x02 | LOGIN_BAD_ACCT            | Bad/invalid account          |
| 0x03 | LOGIN_SERVER_UNAVAILABLE  | Server currently unavailable |
| 0x04 | LOGIN_ACCT_ALREADY_LOGGED | Account is already logged in |
| 0x05 | LOGIN_ACCT_LOCKED         | Account has been locked      |

---

| Field Name | Field Type | Notes                                                                                                                                      |
| ---------- | ---------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Code       | byte       | Login response code (see above)                                                                                                            |
| UserID     | uint       | ID of user in database? **_Only sent on positive login response._**                                                                        |
| UserName   | cstring    | Username? Seems to be used for some URL stuff, as it's url-encoded by the client upon receipt. **_Only sent on positive login response._** |

<br>

### **0x1B5D - `S_START_STREAM`**
Seems to tell the client that the connection is ready for the initial login handshake, which prompts the client to send over `C_REQUEST_LOGIN`.


---

| Field Name | Field Type | Notes                                                   |
| ---------- | ---------- | ------------------------------------------------------- |
| Salt       | cstring    | The salt to use in hashing the passwords for transport. |

<br>

### **0x1Bd8 - `S_PIGGY_BANK`**
A packet describing a  user's "piggy bank," i.e. their collection of shells. It's unclear if this has any other use other than updating the current user's shells, but since there's no UserID field, this is highly unlikely.

---

| Field Name | Field Type | Notes                      |
| ---------- | ---------- | -------------------------- |
| Gold       | uint       | Number of gold shells      |
| Pink       | uint       | Number of pink shells      |
| Green      | uint       | Number of green shells     |
| Prize      | uint       | Number of prize/referrals? |

<br>

### **0x1BF7 - `S_PET_LIST`**
Arbitrary list of pets. It's not clear where exactly this is meant to be used, but if it's used during the initial loading processes, and the pet owner IDs match up with the user's ID, it's considered to be that user's pet, and is added to their lower bar.

---

| Field Name | Field Type | Notes                                |
| ---------- | ---------- | ------------------------------------ |
| UserID     | uint       | The user whose pets these are.       |
| Len        | ushort     | Number of pets in the following list |

The following field group is repeated `Len` times:

| Field Name | Field Type | Notes                                                   |
| ---------- | ---------- | ------------------------------------------------------- |
| PetID      | uint       | The ID of the pet                                       |
| PetName    | cstring    | The name of the pet                                     |
| PortraitNo | uint       | The portrait ID of the pet                              |
| Index      | byte       | Index of the pet in the local pet list - starts from 1. |
| Gender     | bool       | `0/false` is male, `1/true` is female.                  |

<br>

### **0x1BFD - `S_BOX_LIST`**
Seems to be a list of storage boxes for the current user. Doesn't really do much on its own, aside from set up the boxes in the inventory window (albeit useless w/o item slots, which are currently unable to be added?)

---

| Field Name | Field Type | Notes                                 |
| ---------- | ---------- | ------------------------------------- |
| Len        | ushort     | Number of boxes in the following list |

The following field group is repeated `Len` times:

| Field Name | Field Type | Notes                              |
| ---------- | ---------- | ---------------------------------- |
| Index?     | ushort     | Unknown value. Might be the index? |
| BoxName    | cstring    | Name of the box.                   |

<br>

### **0x1D4D - `S_LOAD_END`**
Seems to tell the client that the server is done giving it initial data, and
that it should begin its own precaching and loading process.

---

| Field Name | Field Type | Notes |
| ---------- | ---------- | ----- |
(no fields)

<br>
<br>
<br>
<br>

## **Serverbound (C->S)**
### **0x138A - `C_REQUEST_LOGIN`**
Response to `S_START_STREAM` - contains username, password hash, and some
extra (presumably telemetry related) data.

Server should (assumably) return an `S_LOGIN`, as this is currently the only
known packet that pushes along the process at this point.

---

| Field Name   | Field Type | Notes                                                                                                 |
| ------------ | ---------- | ----------------------------------------------------------------------------------------------------- |
| Username     | cstring    | Client username (for validation)                                                                      |
| PassHash     | cstring    | Client password hash (for validation)                                                                 |
| [unknown]    | cstring    | Always `""` ?                                                                                         |
| CPUSpeed     | cstring    | This doesn't work on the machine this document is written on, likely because it's W64 instead of W32. |
| PhysMemory   | uint       | This tends to overflow on machines with more than 4gb of memory, so it's unlikely to be useful.       |
| OSName       | cstring    | Name of the operating system the client is running on                                                 |
| Resolution   | cstring    | Resolution and bit depth of the client                                                                |
| IsAroundRand | byte       | Unknown function                                                                                      |

<br>

### **0x1421 - Client Interaction Code?**

Unknown purpose. Seems to be sent in interactions with certain UI elements,
but this isn't for sure.

Codes seem to be divided as follows:

| Code          | Name                | Description                                                                          |
| ------------- | ------------------- | ------------------------------------------------------------------------------------ |
| 0x6D60-0x6D6B | CLIENT_LOAD_PHASE_X | Seems to be acknowledgement from the client that the loading phase is being executed |
---

| Field Name | Field Type | Notes        |
| ---------- | ---------- | ------------ |
| Code       | ushort     | Unknown code |

<br>

### **0x14A0 - Client Information Code?**

Unknown purpose. Sent in a bunch of different scenarios, seemingly to update
the server on what the client is thinking.

Codes seem to be divided as follows:

| Code   | Name                | Description                                                                                                                                       |
| ------ | ------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| 0x0000 | CLIENT_LOGIN_OK     | Seems to be an ACK from the client on successful login.                                                                                           |
| 0x0001 | CLIENT_WINDOW_CLOSE | Sent alongside CFrameWnd::OnClose, and is part and parcel to the client exiting, so probably to inform the server that the window is now closing. |

---

| Field Name | Field Type | Notes                               |
| ---------- | ---------- | ----------------------------------- |
| Code       | ushort     | Client information code (see above) |