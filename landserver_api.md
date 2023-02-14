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

| Code | Name                      | Description                                                |
| ---- | ------------------------- | ---------------------------------------------------------- |
| 0x00 | LOGIN_OK                  | Login good - proceed                                       |
| 0x01 | LOGIN_BAD_PASS            | Bad Password                                               |
| 0x02 | LOGIN_BAD_ACCT            | Bad/invalid account                                        |
| 0x03 | LOGIN_SERVER_UNAVAILABLE  | Server currently unavailable                               |
| 0x04 | LOGIN_ACCT_ALREADY_LOGGED | Account is already logged in                               |
| 0x05 | LOGIN_ACCT_LOCKED         | Account has been locked                                    |
| 0x06 | LOGIN_ACCT_NEED_YAM       | Unknown - Yam seems to be a Chinese social network.        |
| 0x07 | LOGIN_OK_SHOW_YAM         | Unknown - Yam seems to be a Chinese social network.        |
| 0x08 | LOGIN_ERR_SUPERUSER       | Unknown - original description is "CannotLoginBySuperUser" |

---

| Field Name | Field Type | Notes                                                                                                                                      |
| ---------- | ---------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Code       | byte       | Login response code (see above)                                                                                                            |
| UserID     | uint       | ID of user in database? **_Only sent on positive login response._**                                                                        |
| UserName   | cstring    | Username? Seems to be used for some URL stuff, as it's URL-encoded by the client upon receipt. **_Only sent on positive login response._** |

<br>

### **0x1B5D - `S_START_STREAM`**
Seems to tell the client that the connection is ready for the initial login handshake, which prompts the client to send over `C_REQUEST_LOGIN`.


---

| Field Name | Field Type | Notes                                                   |
| ---------- | ---------- | ------------------------------------------------------- |
| Salt       | cstring    | The salt to use in hashing the passwords for transport. |

<br>

### **0x1BCC - `S_INVENTORY_LIST`**
Main inventory element descriptor lists.

---

| Field Name | Field Type | Notes                           |
| ---------- | ---------- | ------------------------------- |
| InvNo      | ushort     | Inventory number being adressed |
| Len        | ushort     | Number of items                 |


more to be detailed when i don't wanna pass out

<br>

### **0x1BCD - `S_INVENTORY_LIST_START`**
Prompts the client to begin receiving a particular inventory list for an inventory described, presumably by `S_BOX_LIST`, although it's unclear what other places this goes.

---

| Field Name    | Field Type | Notes                           |
| ------------- | ---------- | ------------------------------- |
| InvNo         | ushort     | Inventory number being adressed |
| MysteryString | cstring    | Unknown purpose.                |

<br>


### **0x1BD0 - `S_MY_PET_INFO`**
Seems to be a no-op, with only a logger message being sent. No functionality seemingly implemented.

---

| Field Name | Field Type | Notes |
| ---------- | ---------- | ----- |
_(no fields)_

<br>

### **0x1BD1 - `S_MY_USER_INFO`**
Seems to be a packet sent on the initial load - gives the client data about who is logging in, including their privilege level, "safe-mode", premium member status, and more.

---

| Field Name     | Field Type | Notes                                                                                    |
| -------------- | ---------- | ---------------------------------------------------------------------------------------- |
| AccountNo      | uint       | Account ID of the current user                                                           |
| LangNo         | uint       | Language ID of the current user                                                          |
| UserPhotoNo    | uint       | User photo ID of the current user                                                        |
| PrivilegeLevel | byte       | Privilege level of the user. 0x51 ('3') is known to be "GM" status.                      |
| IsSafeMode     | byte       | Safe mode status.                                                                        |
| IsSubscriber   | bool       | Subscriber status                                                                        |
| IsMSNUser      | byte       | Whether or not the user is an MSN user (controls whether or not you can obtain a panda!) |

<br>

### **0x1BD2 - `S_NOTICE`**
Sends a chat-log "notice" that is, presumably, sent to all clients that receive the packet.

---

| Field Name | Field Type | Notes                                               |
| ---------- | ---------- | --------------------------------------------------- |
| Message?   | cstring    | Presumably a message to be displayed by the client. |


### **0x1BD3 - `S_OPEN_TEXT`**
Seems to be a no-op, with only a logger message being sent. No functionality seemingly implemented.

---

| Field Name | Field Type | Notes |
| ---------- | ---------- | ----- |
_(no fields)_

<br>

### **0x1BD5 - `S_PET_INFO`**
Seems to be a no-op, with only a logger message being sent. No functionality seemingly implemented.

---

| Field Name | Field Type | Notes |
| ---------- | ---------- | ----- |
_(no fields)_

<br>

### **0x1BD8 - `S_PIGGY_BANK`**
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
Sets up a list of inventories (storage boxes) for the user. Each storage box is an inventory that is addressed w/ an `S_INVENTORY_LIST` packet pair.

---

| Field Name | Field Type | Notes                                 |
| ---------- | ---------- | ------------------------------------- |
| Len        | ushort     | Number of boxes in the following list |

The following field group is repeated `Len` times:

| Field Name | Field Type | Notes                 |
| ---------- | ---------- | --------------------- |
| Index?     | ushort     | InvNo of the new box. |
| BoxName    | cstring    | Name of the box.      |

<br>

### **0x1c3c - `S_ADMIN_LIST`
TODO: Unknown. Likely propogates a list of admin usrs?

---

| Field Name | Field Type | Notes                                 |
| ---------- | ---------- | ------------------------------------- |
| Len        | ushort     | Number of users in the following list |


The following field group is repeated `Len` times:

| Field Name  | Field Type | Notes                 |
| ----------- | ---------- | --------------------- |
| User ID     | ushort     | User ID of an admin   |


### **0x1C5D - `S_SEND_FRIENDSHIP_RING`**
Responds to an attempt to send a friendship ring to someone on your friends list.

Result codes are as follows:


| Code   | Name                        | Description                                                                                    |
| ------ | --------------------------- | ---------------------------------------------------------------------------------------------- |
| 0x0000 | SEND_RING_OK                | Ring was successfully sent to the specified user.                                              |
| 0x0001 | SEND_RING_ERR_MAXSEND_OVER  | Ring was unable to be sent, as the sender has already sent the allotted quota of rings.        |
| 0x0002 | SEND_RING_ERR_MAXRECV_OVER  | Ring was unable to be sent, as the recipient has already received the allotted quota of rings. |
| 0x0003 | SEND_RING_ERR_NO_MONEY      | Ring was unable to be sent, as the sender doesn't possess the funds to send it.                |
| 0x0004 | SEND_RING_ERR_ALREADY_GIVEN | Ring was unable to be sent, as the sender has already sent a ring to the recipient.            |
| 0x0005 | SEND_RING_ERR_BLOCKED       | Ring was unable to be given, as the sender has blocked the recipient.                          |
| 0x0006 | SEND_RING_ERR_BLOCKING      | Ring was unable to be given, as the recipient is blocking the sender.                          |
| 0x0007 | SEND_RING_ERR_SERVER_ERROR  | Ring was unable to be given because of a server error.                                         |

---

| Field Name | Field Type | Notes                            |
| ---------- | ---------- | -------------------------------- |
| Result     | ushort     | Follows result code table above. |

<br>

### **0x1D4D - `S_LOAD_END`**
Seems to tell the client that the server is done giving it initial data, and
that it should begin its own precaching and loading process.

---

| Field Name | Field Type | Notes |
| ---------- | ---------- | ----- |
_(no fields)_

<br>
<br>
<br>
<br>

## **Serverbound (C->S)**
### **0x138A - `C_REQUEST_LOGIN`**
Response to `S_START_STREAM` - contains username, password hash, and some
extra (presumably telemetry related) data.

Server should (assumedly) return an `S_LOGIN`, as this is currently the only
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

### **0x13FF - `C_REQUEST_INVENTORY`**

Requests the contents of the specified inventory number.

---

| Field Name | Field Type | Notes                       |
| ---------- | ---------- | --------------------------- |
| Inv. No    | short      | ID of request inventory     |


### **0x141C - `C_REQUEST_USER`**

Seems to request information about users that the game doesn't know about yet.

---

| Field Name | Field Type | Notes                       |
| ---------- | ---------- | --------------------------- |
| Username   | cstring    | Username of requested user. |


### **0x1421 - `C_LOG_GUI`**

Logs GUI interactions, presumably for the purpose of validating input against the real reaction times of a human?
Or that they're being sent at all? Anti botting?

Codes seem to be divided as follows:

| Code  | Name                                   | Description |
| ----- | -------------------------------------- | ----------- |
| 0     | kLogGUI_Piano                          |             |
| 1     | kLogGUI_Map                            |             |
| 2     | kLogGUI_GiftBox                        |             |
| 3     | kLogGUI_DeliveryBox                    |             |
| 4     | kLogGUI_PiggyBank                      |             |
| 5     | kLogGUI_TextureControl                 |             |
| 6     | kLogGUI_ChangePet                      |             |
| 100   | kLogGUI_Pet_NamePanel                  |             |
| 101   | kLogGUI_Pet_TravelJournal              |             |
| 102   | kLogGUI_Pet_GoAway                     |             |
| 103   | kLogGUI_Pet_PetsBlog                   |             |
| 104   | kLogGUI_Pet_OwnersBlog                 |             |
| 105   | kLogGUI_Pet_OwnersProfile              |             |
| 106   | kLogGUI_Pet_OwnersSendIKU              |             |
| 107   | kLogGUI_Pet_OwnersIM                   |             |
| 108   | kLogGUI_Pet_Status                     |             |
| 109   | kLogGUI_Pet_SendDeliveryGift           |             |
| 110   | kLogGUI_Pet_CallMyPet                  |             |
| 111   | kLogGUI_Pet_BlockUser                  |             |
| 112   | kLogGUI_Pet_WanderingControl           |             |
| 113   | kLogGUI_Pet_DeletePet                  |             |
| 200   | kLogGUI_Main_ViewUserProfile           |             |
| 201   | kLogGUI_Main_ViewPetProfile            |             |
| 202   | kLogGUI_Main_ViewFriend                |             |
| 203   | kLogGUI_Main_ViewMsgPalette            |             |
| 204   | kLogGUI_Main_ViewGame                  |             |
| 205   | kLogGUI_Main_ViewWhatsNew              |             |
| 206   | kLogGUI_Main_ViewInventory             |             |
| 207   | kLogGUI_Main_ViewStore                 |             |
| 208   | kLogGUI_Main_ViewWWW                   |             |
| 209   | kLogGUI_Main_ViewWebHelp               |             |
| 210   | kLogGUI_Main_Help                      |             |
| 211   | kLogGUI_Main_Close                     |             |
| 212   | kLogGUI_Main_Mini                      |             |
| 213   | kLogGUI_Main_Exit                      |             |
| 214   | kLogGUI_Main_Option                    |             |
| 215   | kLogGUI_Main_PetPortraitSlot1          |             |
| 216   | kLogGUI_Main_PetPortraitSlot2          |             |
| 217   | kLogGUI_Main_PetPortraitSlot3          |             |
| 218   | kLogGUI_Main_PetPortraitSlot4          |             |
| 219   | kLogGUI_Main_ViewEmail                 |             |
| 220   | kLogGUI_Main_ViewBadUser               |             |
| 300   | kLogGUI_Cmd_CallMyPet                  |             |
| 301   | kLogGUI_Cmd_MakePlayPen                |             |
| 302   | kLogGUI_Cmd_RemovePlayPen              |             |
| 303   | kLogGUI_Cmd_Option                     |             |
| 400   | kLogGUI_Frd_IM                         |             |
| 401   | kLogGUI_Frd_SendPet                    |             |
| 402   | kLogGUI_Frd_SendMessage                |             |
| 403   | kLogGUI_Frd_ShowFriend                 |             |
| 404   | kLogGUI_Frd_ToggleView                 |             |
| 405   | kLogGUI_Frd_ShowProfile                |             |
| 406   | kLogGUI_Frd_ShowBlog                   |             |
| 407   | kLogGUI_Frd_Privous                    |             |
| 408   | kLogGUI_Frd_Next                       |             |
| 409   | kLogGUI_Frd_Help                       |             |
| 410   | kLogGUI_Frd_AddAsFriend                |             |
| 411   | kLogGUI_Frd_AddToBlockList             |             |
| 412   | kLogGUI_Frd_ShowBlockList              |             |
| 500   | kLogGUI_Plt_CreateMsg                  |             |
| 501   | kLogGUI_Plt_AddWordORPic               |             |
| 502   | kLogGUI_Plt_InBox                      |             |
| 503   | kLogGUI_Plt_OutBox                     |             |
| 504   | kLogGUI_Plt_Favorite                   |             |
| 505   | kLogGUI_Plt_Privous                    |             |
| 506   | kLogGUI_Plt_Next                       |             |
| 507   | kLogGUI_Plt_Search                     |             |
| 508   | kLogGUI_Plt_Help                       |             |
| 509   | kLogGUI_Plt_ShowBlog                   |             |
| 510   | kLogGUI_Plt_IM                         |             |
| 511   | kLogGUI_Plt_AddAsFriend                |             |
| 512   | kLogGUI_Plt_ShowProfile                |             |
| 513   | kLogGUI_Plt_AddToBlockList             |             |
| 600   | kLogGUI_MBox_Read                      |             |
| 601   | kLogGUI_MBox_Delete                    |             |
| 602   | kLogGUI_MBox_Palette                   |             |
| 603   | kLogGUI_MBox_InBox                     |             |
| 604   | kLogGUI_MBox_OutBox                    |             |
| 605   | kLogGUI_MBox_Favorite                  |             |
| 606   | kLogGUI_MBox_Help                      |             |
| 607   | kLogGUI_MBox_AddFavorite               |             |
| 608   | kLogGUI_MBox_DeleteAll                 |             |
| 700   | kLogGUI_Mat_SendTo                     |             |
| 701   | kLogGUI_Mat_Send                       |             |
| 702   | kLogGUI_Mat_DeleteIku                  |             |
| 703   | kLogGUI_Mat_Cancel                     |             |
| 704   | kLogGUI_Mat_Help                       |             |
| 705   | kLogGUI_Mat_ViewUserProfile            |             |
| 800   | kLogGUI_Inv_Recycle                    |             |
| 801   | kLogGUI_Inv_Help                       |             |
| 802   | kLogGUI_Inv_ViewPetInventory           |             |
| 803   | kLogGUI_Inv_NewInventory               |             |
| 804   | kLogGUI_Inv_MyStore                    |             |
| 805   | kLogGUI_Inv_SendGift                   |             |
| 900   | kLogGUI_Map_TravelHistory              |             |
| 901   | kLogGUI_Map_CountTravel                |             |
| 902   | kLogGUI_Map_CountUsers                 |             |
| 903   | kLogGUI_Map_Help                       |             |
| 1000  | kLogGUI_Txt_ViewControl                |             |
| 1001  | kLogGUI_Txt_MoreControl                |             |
| 1002  | kLogGUI_Txt_PrevousControl             |             |
| 1003  | kLogGUI_Txt_Help                       |             |
| 1100  | kLogGUI_ChangePet_Left                 |             |
| 1101  | kLogGUI_ChangePet_Right                |             |
| 1102  | kLogGUI_ChangePet_Help                 |             |
| 1200  | kLogGUI_WrapGift_Help                  |             |
| 1201  | kLogGUI_WrapGift_GoShop                |             |
| 1202  | kLogGUI_WrapGift_OK                    |             |
| 1203  | kLogGUI_WrapGift_Cancel                |             |
| 1300  | kLogGUI_GotGift_Help                   |             |
| 1301  | kLogGUI_GotGift_OK                     |             |
| 1302  | kLogGUI_GotGift_Cancel                 |             |
| 1400  | kLogGUI_AddPic_Help                    |             |
| 1401  | kLogGUI_AddPic_Browse                  |             |
| 1402  | kLogGUI_AddPic_Language                |             |
| 1500  | kLogGUI_Option_Help                    |             |
| 1501  | kLogGUI_Option_HideObj                 |             |
| 1502  | kLogGUI_Option_Mute                    |             |
| 1503  | kLogGUI_Option_PlayPen                 |             |
| 1504  | kLogGUI_Option_OK                      |             |
| 1505  | kLogGUI_Option_Language                |             |
| 1506  | kLogGUI_Option_PetNum                  |             |
| 1507  | kLogGUI_Option_VisitMode               |             |
| 1508  | kLogGUI_Option_SendToBG                |             |
| 1509  | kLogGUI_Option_StayMode                |             |
| 1510  | kLogGUI_Option_AroundLand              |             |
| 1511  | kLogGUI_Option_ShowNamePlate           |             |
| 1512  | kLogGUI_Option_WindowMode              |             |
| 1513  | kLogGUI_Option_Close                   |             |
| 1600  | kLogGUI_PetInv_Close                   |             |
| 1601  | kLogGUI_PetInv_Help                    |             |
| 1602  | kLogGUI_PetInv_Detach                  |             |
| 1603  | kLogGUI_PetInv_Inventory               |             |
| 1700  | kLogGUI_Add_Help                       |             |
| 1701  | kLogGUI_Add_Privous                    |             |
| 1800  | kLogGUI_MyStore_Help                   |             |
| 1801  | kLogGUI_MyStore_Status                 |             |
| 1802  | kLogGUI_MyStroe_Sell                   |             |
| 1900  | kLogGUI_PetStatus_Help                 |             |
| 2000  | kLogGUI_Solid_Help                     |             |
| 2001  | kLogGUI_Solid_Detach                   |             |
| 2100  | kLogGUI_UserCreateItem_Help            |             |
| 2200  | kLogGUI_UserAttach_Picture             |             |
| 2201  | kLogGUI_UserAttach_Extract             |             |
| 2202  | kLogGUI_UserAttach_Browse              |             |
| 2203  | kLogGUI_UserAttach_Upload              |             |
| 2204  | kLogGUI_UserAttach_Camera              |             |
| 2300  | kLogGUI_UserNamePlate_Extract          |             |
| 2301  | kLogGUI_UserNamePlate_Browse           |             |
| 2302  | kLogGUI_UserNamePlate_Upload           |             |
| 2400  | kLogGUI_Breed_Converting_Help          |             |
| 2401  | kLogGUI_Breed_Converting_Close         |             |
| 2402  | kLogGUI_Breed_Converting_Mini          |             |
| 2500  | kLogGUI_Quantity_Close                 |             |
| 2600  | kLogGUI_Quest_Dlg                      |             |
| 2601  | kLogGUI_Quest_Accept                   |             |
| 2602  | kLogGUI_Quest_Complete                 |             |
| 2700  | kLogGUI_PetCreation_RotatePet          |             |
| 2701  | kLogGUI_PetCreation_PetGroup           |             |
| 2702  | kLogGUI_PetCreation_SelectPet          |             |
| 2703  | kLogGUI_PetCreation_Cat                |             |
| 2704  | kLogGUI_PetCreation_Dog                |             |
| 2705  | kLogGUI_PetCreation_Panda              |             |
| 2706  | kLogGUI_PetCreation_Horse              |             |
| 2707  | kLogGUI_PetCreation_Monkey             |             |
| 2708  | kLogGUI_PetCreation_PetName            |             |
| 2709  | kLogGUI_PetCreation_Male               |             |
| 2710  | kLogGUI_PetCreation_Female             |             |
| 2711  | kLogGUI_PetCreation_ChangePattern      |             |
| 2712  | kLogGUI_PetCreation_ChangeNumMetaSkin  |             |
| 2713  | kLogGUI_PetCreation_ChangeColor        |             |
| 2714  | kLogGUI_PetCreation_ChangeBellyColor   |             |
| 2715  | kLogGUI_PetCreation_ChangePatternColor |             |
| 2716  | kLogGUI_PetCreation_ChangeEyeColor     |             |
| 2717  | kLogGUI_PetCreation_EnterDialog        |             |
| 2718  | kLogGUI_PetCreation_CreatePet          |             |
| 2750  | kLogGUI_PetCreation_CreatePetResult    |             |
| 27500 | kLogGUI_LoadingInit                    |             |
| 28000 | kLogGUI_Loading                        |             |
| 28500 | kLogGUI_LoadingDone                    |             |

---

| Field Name | Field Type | Notes        |
| ---------- | ---------- | ------------ |
| Code       | ushort     | Unknown code |

<br>

### **0x142A - `C_OPEN_GIFT`**

Sent by the client on the call of the Lua function `useItem` on an element of `ELEMENT_TYPE_GIFT_ITEM`. Tells the server to open the gift.

| Field Name | Field Type | Notes                                                |
| ---------- | ---------- | ---------------------------------------------------- |
| InvNo      | ushort     | The ID of the Inventory in which the gift is located |
| SlotIndex  | ushort     | The slot index of the gift                           |

<br>

### **0x142B - `C_TAKE_GIFT`**

Sent by the client on the call of the Lua function `TakeItem`. Tells the server that the gift was taken rather than rejected (rejections seemingly can only occur if the item is a Cash On Delivery item).

| Field Name | Field Type | Notes                                                |
| ---------- | ---------- | ---------------------------------------------------- |
| InvNo      | ushort     | The ID of the Inventory in which the gift is located |
| SlotIndex  | ushort     | The slot index of the gift                           |

<br>

### **0x14A0 - `C_WRITE_LOG`**

Called whenever the client Lua decides to call `gp.writeLog` with a corresponding enum.

Codes seem to be divided as follows:

| Code | Name                      | Description |
| ---- | ------------------------- | ----------- |
| 0    | kGPL_Login                |             |
| 1    | kGPL_Logout               |             |
| 2    | kGPL_Lodingstart          |             |
| 3    | kGPL_Lodingend            |             |
| 4    | kGPL_MakePet              |             |
| 5    | kGPL_DropItem             |             |
| 6    | kGPL_EnterPet             |             |
| 7    | kGPL_AttachEquipItem      |             |
| 8    | kGPL_SellMystore          |             |
| 9    | kGPL_RecycleItem          |             |
| 10   | kGPL_UseItemMaker         |             |
| 11   | kGPL_MakeBox              |             |
| 12   | kGPL_BuyShellPage         |             |
| 13   | kGPL_SearchFriend         |             |
| 14   | kGPL_SendPet              |             |
| 15   | kGPL_ShowFriendProfile    |             |
| 16   | kGPL_BlockFriend          |             |
| 17   | kGPL_MoveFriendLand       |             |
| 18   | kGPL_SendFriendshipRing   |             |
| 19   | kGPL_InvitePet            |             |
| 20   | kGPL_SearchIku            |             |
| 21   | kGPL_SendIku              |             |
| 22   | kGPL_ReadIku              |             |
| 23   | kGPL_SendPresent          |             |
| 24   | kGPL_ReceivePresentWeb    |             |
| 25   | kGPL_SendPresentWeb       |             |
| 26   | kGPL_GoChat               |             |
| 27   | kGPL_ForumWeb             |             |
| 28   | kGPL_CommunityWeb         |             |
| 29   | kGPL_MyBlogWeb            |             |
| 30   | kGPL_GameRankingWeb       |             |
| 31   | kGPL_Shoping              |             |
| 32   | kGPL_MoveLand             |             |
| 33   | kGPL_LandBook             |             |
| 34   | kGPL_LandPermission       |             |
| 35   | kGPL_LandSale             |             |
| 36   | kGPL_LandBuy              |             |
| 37   | kGPL_LandBuytoUserLand    |             |
| 38   | kGPL_ReturnDecoration     |             |
| 39   | kGPL_LockDecoration       |             |
| 40   | kGPL_ChangeLandName       |             |
| 41   | kGPL_QuestAccept          |             |
| 42   | kGPL_QuestComplete        |             |
| 43   | kGPL_LearnRecipe          |             |
| 44   | kGPL_CraftingMakeItem     |             |
| 45   | kGPL_BattleMonter         |             |
| 46   | kGPL_SetOption            |             |
| 47   | kGPL_NoticeWeb            |             |
| 48   | kGPL_EmailWeb             |             |
| 49   | kGPL_ReportUserWeb        |             |
| 50   | kGPL_FAQWeb               |             |
| 51   | kGPL_GameGuideWeb         |             |
| 52   | kGPL_TrainingGuideWeb     |             |
| 53   | kGPL_LevelingGuideWeb     |             |
| 54   | kGPL_ItemMakerWeb         |             |
| 55   | kGPL_ChangePetSlot        |             |
| 56   | kGPL_TagItem              |             |
| 57   | kGPL_3DShopRegister       |             |
| 58   | kGPL_3DShopBuy            |             |
| 59   | kGPL_BuySubscription      |             |
| 60   | kGPL_AddFriend            |             |
| 61   | kGPL_UserKick             |             |
| 62   | kGPL_GeneratorFishing     |             |
| 63   | kGPL_PetAction            |             |
| 64   | kGPL_ChatFilter           |             |
| 65   | kGPL_Chating              |             |
| 66   | kGPL_PlayMiniGame         |             |
| 67   | kGPL_PlaySound            |             |
| 68   | kGPL_EnterHouse           |             |
| 69   | kGPL_ChangeWallPaper      |             |
| 70   | kGPL_ChangeSkyBox         |             |
| 71   | kGPL_ItemDrop             |             |
| 72   | kGPL_ChangeCameraMode     |             |
| 73   | kGPL_CameraControl        |             |
| 74   | kGPL_JumpStone            |             |
| 75   | kGPL_CallPet              |             |
| 76   | kGPL_InitCraftSkill       |             |
| 77   | kGPL_CancelFriendshipRing |             |
| 78   | kGPL_SenduserPet          |             |
| 79   | kGPL_ShowTag              |             |
| 80   | kGPL_DefaultLand          |             |
| 81   | kGPL_SetReturnLand        |             |
| 82   | kGPL_BreedChange          |             |
| 83   | kGPL_UserBlog             |             |
| 84   | kGPL_Wishper              |             |
| 85   | kGPL_PetAdoption          |             |
| 86   | kGPL_Petting              |             |
| 87   | kGPL_GoMyLand             |             |
| 88   | kGPL_LeaveMyLand          |             |
| 89   | kGPL_Max                  |             |

---

| Field Name | Field Type | Notes                               |
| ---------- | ---------- | ----------------------------------- |
| Code       | ushort     | Client information code (see above) |

<br>

### **0x1648 - `C_SET_LEVEL`**
I'm not sure if this is ever sent legitimately, but it seems to tell the server "hey, set me to this level, thanks." Very cool.

---

| Field Name | Field Type | Notes              |
| ---------- | ---------- | ------------------ |
| Level      | uint       | New level for user |


## Known Client Packets (TBD)

* 0x1581 (kick)
* 0x1433 (change online status) 
* 0x13F4 (recycle item - takes position and quantity discarded)
* 0x141B (unknown - sends user ID) - probably requests a petlist?
* 0x1400 (max visiting pet count)
* 0x1412 (send pet - pet number and account number - seems to requisition the server for pet information)
* 0x157C (local land no?)
* 0x145b (invite pet prepare)
* 0x145b (invite pet)
* 0x149E (quest id? sends quest no. from quest XML)
* 0x149E (quest language [just sends the gui lang no.])
* 0x13f3 (call my pet - one unknown integer argument)
* 0x141B (requests a users_list?)
* 0x1c70 (buy land)