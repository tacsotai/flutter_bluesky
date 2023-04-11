// lexicons % tree
// .
// ├── app
// │   └── bsky
// │       ├── actor
// │       │   ├── defs.json
// │       │   ├── getProfile.json
// │       │   ├── getProfiles.json
// │       │   ├── getSuggestions.json
// │       │   ├── profile.json
// │       │   ├── searchActors.json
// │       │   └── searchActorsTypeahead.json
// │       ├── embed
// │       │   ├── external.json
// │       │   ├── images.json
// │       │   ├── record.json
// │       │   └── recordWithMedia.json
// │       ├── feed
// │       │   ├── defs.json
// │       │   ├── getAuthorFeed.json
// │       │   ├── getLikes.json
// │       │   ├── getPostThread.json
// │       │   ├── getRepostedBy.json
// │       │   ├── getTimeline.json
// │       │   ├── like.json
// │       │   ├── post.json
// │       │   └── repost.json
// │       ├── graph
// │       │   ├── follow.json
// │       │   ├── getFollowers.json
// │       │   ├── getFollows.json
// │       │   ├── getMutes.json
// │       │   ├── muteActor.json
// │       │   └── unmuteActor.json
// │       ├── notification
// │       │   ├── getUnreadCount.json
// │       │   ├── listNotifications.json
// │       │   └── updateSeen.json
// │       ├── richtext
// │       │   └── facet.json
// │       └── unspecced
// │           └── getPopular.json
// └── com
//     └── atproto
//         ├── admin
//         │   ├── defs.json
//         │   ├── disableInviteCodes.json
//         │   ├── getInviteCodes.json
//         │   ├── getModerationAction.json
//         │   ├── getModerationActions.json
//         │   ├── getModerationReport.json
//         │   ├── getModerationReports.json
//         │   ├── getRecord.json
//         │   ├── getRepo.json
//         │   ├── resolveModerationReports.json
//         │   ├── reverseModerationAction.json
//         │   ├── searchRepos.json
//         │   └── takeModerationAction.json
//         ├── identity
//         │   ├── resolveHandle.json
//         │   └── updateHandle.json
//         ├── moderation
//         │   ├── createReport.json
//         │   └── defs.json
//         ├── repo
//         │   ├── applyWrites.json
//         │   ├── createRecord.json
//         │   ├── deleteRecord.json
//         │   ├── describeRepo.json
//         │   ├── getRecord.json
//         │   ├── listRecords.json
//         │   ├── putRecord.json
//         │   ├── strongRef.json
//         │   └── uploadBlob.json
//         ├── server
//         │   ├── createAccount.json
//         │   ├── createInviteCode.json
//         │   ├── createSession.json
//         │   ├── defs.json
//         │   ├── deleteAccount.json
//         │   ├── deleteSession.json
//         │   ├── describeServer.json
//         │   ├── getAccountInviteCodes.json
//         │   ├── getSession.json
//         │   ├── refreshSession.json
//         │   ├── requestAccountDelete.json
//         │   ├── requestPasswordReset.json
//         │   └── resetPassword.json
//         └── sync
//             ├── getBlob.json
//             ├── getBlocks.json
//             ├── getCheckout.json
//             ├── getCommitPath.json
//             ├── getHead.json
//             ├── getRecord.json
//             ├── getRepo.json
//             ├── listBlobs.json
//             ├── notifyOfUpdate.json
//             ├── requestCrawl.json
//             └── subscribeRepos.json

// These exports define minimum lexicons as API with model.
import 'package:flutter_bluesky/api/atproto.dart';
import 'package:flutter_bluesky/api/bluesky.dart';

var atproto = Atproto();
var bluesky = Bluesky();
