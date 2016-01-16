#include "fft_func.h"
#include "multiplier.h"
#include <map>
#include "fixpoint_cpp_simulator.h"
#include <iostream>
#include <fstream>

using namespace std;

map<int, param> param_pairs;

// lookup table
const int crl_1280[256][5] = {{0, 256, 512, 768, 1024},{1025, 1, 257, 513, 769},{770, 1026, 2, 258, 514},{515, 771, 1027, 3, 259},{260, 516, 772, 1028, 4},{5, 261, 517, 773, 1029},{1030, 6, 262, 518, 774},{775, 1031, 7, 263, 519},{520, 776, 1032, 8, 264},{265, 521, 777, 1033, 9},{10, 266, 522, 778, 1034},{1035, 11, 267, 523, 779},{780, 1036, 12, 268, 524},{525, 781, 1037, 13, 269},{270, 526, 782, 1038, 14},{15, 271, 527, 783, 1039},{1040, 16, 272, 528, 784},{785, 1041, 17, 273, 529},{530, 786, 1042, 18, 274},{275, 531, 787, 1043, 19},{20, 276, 532, 788, 1044},{1045, 21, 277, 533, 789},{790, 1046, 22, 278, 534},{535, 791, 1047, 23, 279},{280, 536, 792, 1048, 24},{25, 281, 537, 793, 1049},{1050, 26, 282, 538, 794},{795, 1051, 27, 283, 539},{540, 796, 1052, 28, 284},{285, 541, 797, 1053, 29},{30, 286, 542, 798, 1054},{1055, 31, 287, 543, 799},{800, 1056, 32, 288, 544},{545, 801, 1057, 33, 289},{290, 546, 802, 1058, 34},{35, 291, 547, 803, 1059},{1060, 36, 292, 548, 804},{805, 1061, 37, 293, 549},{550, 806, 1062, 38, 294},{295, 551, 807, 1063, 39},{40, 296, 552, 808, 1064},{1065, 41, 297, 553, 809},{810, 1066, 42, 298, 554},{555, 811, 1067, 43, 299},{300, 556, 812, 1068, 44},{45, 301, 557, 813, 1069},{1070, 46, 302, 558, 814},{815, 1071, 47, 303, 559},{560, 816, 1072, 48, 304},{305, 561, 817, 1073, 49},{50, 306, 562, 818, 1074},{1075, 51, 307, 563, 819},{820, 1076, 52, 308, 564},{565, 821, 1077, 53, 309},{310, 566, 822, 1078, 54},{55, 311, 567, 823, 1079},{1080, 56, 312, 568, 824},{825, 1081, 57, 313, 569},{570, 826, 1082, 58, 314},{315, 571, 827, 1083, 59},{60, 316, 572, 828, 1084},{1085, 61, 317, 573, 829},{830, 1086, 62, 318, 574},{575, 831, 1087, 63, 319},{320, 576, 832, 1088, 64},{65, 321, 577, 833, 1089},{1090, 66, 322, 578, 834},{835, 1091, 67, 323, 579},{580, 836, 1092, 68, 324},{325, 581, 837, 1093, 69},{70, 326, 582, 838, 1094},{1095, 71, 327, 583, 839},{840, 1096, 72, 328, 584},{585, 841, 1097, 73, 329},{330, 586, 842, 1098, 74},{75, 331, 587, 843, 1099},{1100, 76, 332, 588, 844},{845, 1101, 77, 333, 589},{590, 846, 1102, 78, 334},{335, 591, 847, 1103, 79},{80, 336, 592, 848, 1104},{1105, 81, 337, 593, 849},{850, 1106, 82, 338, 594},{595, 851, 1107, 83, 339},{340, 596, 852, 1108, 84},{85, 341, 597, 853, 1109},{1110, 86, 342, 598, 854},{855, 1111, 87, 343, 599},{600, 856, 1112, 88, 344},{345, 601, 857, 1113, 89},{90, 346, 602, 858, 1114},{1115, 91, 347, 603, 859},{860, 1116, 92, 348, 604},{605, 861, 1117, 93, 349},{350, 606, 862, 1118, 94},{95, 351, 607, 863, 1119},{1120, 96, 352, 608, 864},{865, 1121, 97, 353, 609},{610, 866, 1122, 98, 354},{355, 611, 867, 1123, 99},{100, 356, 612, 868, 1124},{1125, 101, 357, 613, 869},{870, 1126, 102, 358, 614},{615, 871, 1127, 103, 359},{360, 616, 872, 1128, 104},{105, 361, 617, 873, 1129},{1130, 106, 362, 618, 874},{875, 1131, 107, 363, 619},{620, 876, 1132, 108, 364},{365, 621, 877, 1133, 109},{110, 366, 622, 878, 1134},{1135, 111, 367, 623, 879},{880, 1136, 112, 368, 624},{625, 881, 1137, 113, 369},{370, 626, 882, 1138, 114},{115, 371, 627, 883, 1139},{1140, 116, 372, 628, 884},{885, 1141, 117, 373, 629},{630, 886, 1142, 118, 374},{375, 631, 887, 1143, 119},{120, 376, 632, 888, 1144},{1145, 121, 377, 633, 889},{890, 1146, 122, 378, 634},{635, 891, 1147, 123, 379},{380, 636, 892, 1148, 124},{125, 381, 637, 893, 1149},{1150, 126, 382, 638, 894},{895, 1151, 127, 383, 639},{640, 896, 1152, 128, 384},{385, 641, 897, 1153, 129},{130, 386, 642, 898, 1154},{1155, 131, 387, 643, 899},{900, 1156, 132, 388, 644},{645, 901, 1157, 133, 389},{390, 646, 902, 1158, 134},{135, 391, 647, 903, 1159},{1160, 136, 392, 648, 904},{905, 1161, 137, 393, 649},{650, 906, 1162, 138, 394},{395, 651, 907, 1163, 139},{140, 396, 652, 908, 1164},{1165, 141, 397, 653, 909},{910, 1166, 142, 398, 654},{655, 911, 1167, 143, 399},{400, 656, 912, 1168, 144},{145, 401, 657, 913, 1169},{1170, 146, 402, 658, 914},{915, 1171, 147, 403, 659},{660, 916, 1172, 148, 404},{405, 661, 917, 1173, 149},{150, 406, 662, 918, 1174},{1175, 151, 407, 663, 919},{920, 1176, 152, 408, 664},{665, 921, 1177, 153, 409},{410, 666, 922, 1178, 154},{155, 411, 667, 923, 1179},{1180, 156, 412, 668, 924},{925, 1181, 157, 413, 669},{670, 926, 1182, 158, 414},{415, 671, 927, 1183, 159},{160, 416, 672, 928, 1184},{1185, 161, 417, 673, 929},{930, 1186, 162, 418, 674},{675, 931, 1187, 163, 419},{420, 676, 932, 1188, 164},{165, 421, 677, 933, 1189},{1190, 166, 422, 678, 934},{935, 1191, 167, 423, 679},{680, 936, 1192, 168, 424},{425, 681, 937, 1193, 169},{170, 426, 682, 938, 1194},{1195, 171, 427, 683, 939},{940, 1196, 172, 428, 684},{685, 941, 1197, 173, 429},{430, 686, 942, 1198, 174},{175, 431, 687, 943, 1199},{1200, 176, 432, 688, 944},{945, 1201, 177, 433, 689},{690, 946, 1202, 178, 434},{435, 691, 947, 1203, 179},{180, 436, 692, 948, 1204},{1205, 181, 437, 693, 949},{950, 1206, 182, 438, 694},{695, 951, 1207, 183, 439},{440, 696, 952, 1208, 184},{185, 441, 697, 953, 1209},{1210, 186, 442, 698, 954},{955, 1211, 187, 443, 699},{700, 956, 1212, 188, 444},{445, 701, 957, 1213, 189},{190, 446, 702, 958, 1214},{1215, 191, 447, 703, 959},{960, 1216, 192, 448, 704},{705, 961, 1217, 193, 449},{450, 706, 962, 1218, 194},{195, 451, 707, 963, 1219},{1220, 196, 452, 708, 964},{965, 1221, 197, 453, 709},{710, 966, 1222, 198, 454},{455, 711, 967, 1223, 199},{200, 456, 712, 968, 1224},{1225, 201, 457, 713, 969},{970, 1226, 202, 458, 714},{715, 971, 1227, 203, 459},{460, 716, 972, 1228, 204},{205, 461, 717, 973, 1229},{1230, 206, 462, 718, 974},{975, 1231, 207, 463, 719},{720, 976, 1232, 208, 464},{465, 721, 977, 1233, 209},{210, 466, 722, 978, 1234},{1235, 211, 467, 723, 979},{980, 1236, 212, 468, 724},{725, 981, 1237, 213, 469},{470, 726, 982, 1238, 214},{215, 471, 727, 983, 1239},{1240, 216, 472, 728, 984},{985, 1241, 217, 473, 729},{730, 986, 1242, 218, 474},{475, 731, 987, 1243, 219},{220, 476, 732, 988, 1244},{1245, 221, 477, 733, 989},{990, 1246, 222, 478, 734},{735, 991, 1247, 223, 479},{480, 736, 992, 1248, 224},{225, 481, 737, 993, 1249},{1250, 226, 482, 738, 994},{995, 1251, 227, 483, 739},{740, 996, 1252, 228, 484},{485, 741, 997, 1253, 229},{230, 486, 742, 998, 1254},{1255, 231, 487, 743, 999},{1000, 1256, 232, 488, 744},{745, 1001, 1257, 233, 489},{490, 746, 1002, 1258, 234},{235, 491, 747, 1003, 1259},{1260, 236, 492, 748, 1004},{1005, 1261, 237, 493, 749},{750, 1006, 1262, 238, 494},{495, 751, 1007, 1263, 239},{240, 496, 752, 1008, 1264},{1265, 241, 497, 753, 1009},{1010, 1266, 242, 498, 754},{755, 1011, 1267, 243, 499},{500, 756, 1012, 1268, 244},{245, 501, 757, 1013, 1269},{1270, 246, 502, 758, 1014},{1015, 1271, 247, 503, 759},{760, 1016, 1272, 248, 504},{505, 761, 1017, 1273, 249},{250, 506, 762, 1018, 1274},{1275, 251, 507, 763, 1019},{1020, 1276, 252, 508, 764},{765, 1021, 1277, 253, 509},{510, 766, 1022, 1278, 254},{255, 511, 767, 1023, 1279}};
const int goods_1280[256][5] = {{0, 256, 512, 768, 1024},{5, 261, 517, 773, 1029},{10, 266, 522, 778, 1034},{15, 271, 527, 783, 1039},{20, 276, 532, 788, 1044},{25, 281, 537, 793, 1049},{30, 286, 542, 798, 1054},{35, 291, 547, 803, 1059},{40, 296, 552, 808, 1064},{45, 301, 557, 813, 1069},{50, 306, 562, 818, 1074},{55, 311, 567, 823, 1079},{60, 316, 572, 828, 1084},{65, 321, 577, 833, 1089},{70, 326, 582, 838, 1094},{75, 331, 587, 843, 1099},{80, 336, 592, 848, 1104},{85, 341, 597, 853, 1109},{90, 346, 602, 858, 1114},{95, 351, 607, 863, 1119},{100, 356, 612, 868, 1124},{105, 361, 617, 873, 1129},{110, 366, 622, 878, 1134},{115, 371, 627, 883, 1139},{120, 376, 632, 888, 1144},{125, 381, 637, 893, 1149},{130, 386, 642, 898, 1154},{135, 391, 647, 903, 1159},{140, 396, 652, 908, 1164},{145, 401, 657, 913, 1169},{150, 406, 662, 918, 1174},{155, 411, 667, 923, 1179},{160, 416, 672, 928, 1184},{165, 421, 677, 933, 1189},{170, 426, 682, 938, 1194},{175, 431, 687, 943, 1199},{180, 436, 692, 948, 1204},{185, 441, 697, 953, 1209},{190, 446, 702, 958, 1214},{195, 451, 707, 963, 1219},{200, 456, 712, 968, 1224},{205, 461, 717, 973, 1229},{210, 466, 722, 978, 1234},{215, 471, 727, 983, 1239},{220, 476, 732, 988, 1244},{225, 481, 737, 993, 1249},{230, 486, 742, 998, 1254},{235, 491, 747, 1003, 1259},{240, 496, 752, 1008, 1264},{245, 501, 757, 1013, 1269},{250, 506, 762, 1018, 1274},{255, 511, 767, 1023, 1279},{260, 516, 772, 1028, 4},{265, 521, 777, 1033, 9},{270, 526, 782, 1038, 14},{275, 531, 787, 1043, 19},{280, 536, 792, 1048, 24},{285, 541, 797, 1053, 29},{290, 546, 802, 1058, 34},{295, 551, 807, 1063, 39},{300, 556, 812, 1068, 44},{305, 561, 817, 1073, 49},{310, 566, 822, 1078, 54},{315, 571, 827, 1083, 59},{320, 576, 832, 1088, 64},{325, 581, 837, 1093, 69},{330, 586, 842, 1098, 74},{335, 591, 847, 1103, 79},{340, 596, 852, 1108, 84},{345, 601, 857, 1113, 89},{350, 606, 862, 1118, 94},{355, 611, 867, 1123, 99},{360, 616, 872, 1128, 104},{365, 621, 877, 1133, 109},{370, 626, 882, 1138, 114},{375, 631, 887, 1143, 119},{380, 636, 892, 1148, 124},{385, 641, 897, 1153, 129},{390, 646, 902, 1158, 134},{395, 651, 907, 1163, 139},{400, 656, 912, 1168, 144},{405, 661, 917, 1173, 149},{410, 666, 922, 1178, 154},{415, 671, 927, 1183, 159},{420, 676, 932, 1188, 164},{425, 681, 937, 1193, 169},{430, 686, 942, 1198, 174},{435, 691, 947, 1203, 179},{440, 696, 952, 1208, 184},{445, 701, 957, 1213, 189},{450, 706, 962, 1218, 194},{455, 711, 967, 1223, 199},{460, 716, 972, 1228, 204},{465, 721, 977, 1233, 209},{470, 726, 982, 1238, 214},{475, 731, 987, 1243, 219},{480, 736, 992, 1248, 224},{485, 741, 997, 1253, 229},{490, 746, 1002, 1258, 234},{495, 751, 1007, 1263, 239},{500, 756, 1012, 1268, 244},{505, 761, 1017, 1273, 249},{510, 766, 1022, 1278, 254},{515, 771, 1027, 3, 259},{520, 776, 1032, 8, 264},{525, 781, 1037, 13, 269},{530, 786, 1042, 18, 274},{535, 791, 1047, 23, 279},{540, 796, 1052, 28, 284},{545, 801, 1057, 33, 289},{550, 806, 1062, 38, 294},{555, 811, 1067, 43, 299},{560, 816, 1072, 48, 304},{565, 821, 1077, 53, 309},{570, 826, 1082, 58, 314},{575, 831, 1087, 63, 319},{580, 836, 1092, 68, 324},{585, 841, 1097, 73, 329},{590, 846, 1102, 78, 334},{595, 851, 1107, 83, 339},{600, 856, 1112, 88, 344},{605, 861, 1117, 93, 349},{610, 866, 1122, 98, 354},{615, 871, 1127, 103, 359},{620, 876, 1132, 108, 364},{625, 881, 1137, 113, 369},{630, 886, 1142, 118, 374},{635, 891, 1147, 123, 379},{640, 896, 1152, 128, 384},{645, 901, 1157, 133, 389},{650, 906, 1162, 138, 394},{655, 911, 1167, 143, 399},{660, 916, 1172, 148, 404},{665, 921, 1177, 153, 409},{670, 926, 1182, 158, 414},{675, 931, 1187, 163, 419},{680, 936, 1192, 168, 424},{685, 941, 1197, 173, 429},{690, 946, 1202, 178, 434},{695, 951, 1207, 183, 439},{700, 956, 1212, 188, 444},{705, 961, 1217, 193, 449},{710, 966, 1222, 198, 454},{715, 971, 1227, 203, 459},{720, 976, 1232, 208, 464},{725, 981, 1237, 213, 469},{730, 986, 1242, 218, 474},{735, 991, 1247, 223, 479},{740, 996, 1252, 228, 484},{745, 1001, 1257, 233, 489},{750, 1006, 1262, 238, 494},{755, 1011, 1267, 243, 499},{760, 1016, 1272, 248, 504},{765, 1021, 1277, 253, 509},{770, 1026, 2, 258, 514},{775, 1031, 7, 263, 519},{780, 1036, 12, 268, 524},{785, 1041, 17, 273, 529},{790, 1046, 22, 278, 534},{795, 1051, 27, 283, 539},{800, 1056, 32, 288, 544},{805, 1061, 37, 293, 549},{810, 1066, 42, 298, 554},{815, 1071, 47, 303, 559},{820, 1076, 52, 308, 564},{825, 1081, 57, 313, 569},{830, 1086, 62, 318, 574},{835, 1091, 67, 323, 579},{840, 1096, 72, 328, 584},{845, 1101, 77, 333, 589},{850, 1106, 82, 338, 594},{855, 1111, 87, 343, 599},{860, 1116, 92, 348, 604},{865, 1121, 97, 353, 609},{870, 1126, 102, 358, 614},{875, 1131, 107, 363, 619},{880, 1136, 112, 368, 624},{885, 1141, 117, 373, 629},{890, 1146, 122, 378, 634},{895, 1151, 127, 383, 639},{900, 1156, 132, 388, 644},{905, 1161, 137, 393, 649},{910, 1166, 142, 398, 654},{915, 1171, 147, 403, 659},{920, 1176, 152, 408, 664},{925, 1181, 157, 413, 669},{930, 1186, 162, 418, 674},{935, 1191, 167, 423, 679},{940, 1196, 172, 428, 684},{945, 1201, 177, 433, 689},{950, 1206, 182, 438, 694},{955, 1211, 187, 443, 699},{960, 1216, 192, 448, 704},{965, 1221, 197, 453, 709},{970, 1226, 202, 458, 714},{975, 1231, 207, 463, 719},{980, 1236, 212, 468, 724},{985, 1241, 217, 473, 729},{990, 1246, 222, 478, 734},{995, 1251, 227, 483, 739},{1000, 1256, 232, 488, 744},{1005, 1261, 237, 493, 749},{1010, 1266, 242, 498, 754},{1015, 1271, 247, 503, 759},{1020, 1276, 252, 508, 764},{1025, 1, 257, 513, 769},{1030, 6, 262, 518, 774},{1035, 11, 267, 523, 779},{1040, 16, 272, 528, 784},{1045, 21, 277, 533, 789},{1050, 26, 282, 538, 794},{1055, 31, 287, 543, 799},{1060, 36, 292, 548, 804},{1065, 41, 297, 553, 809},{1070, 46, 302, 558, 814},{1075, 51, 307, 563, 819},{1080, 56, 312, 568, 824},{1085, 61, 317, 573, 829},{1090, 66, 322, 578, 834},{1095, 71, 327, 583, 839},{1100, 76, 332, 588, 844},{1105, 81, 337, 593, 849},{1110, 86, 342, 598, 854},{1115, 91, 347, 603, 859},{1120, 96, 352, 608, 864},{1125, 101, 357, 613, 869},{1130, 106, 362, 618, 874},{1135, 111, 367, 623, 879},{1140, 116, 372, 628, 884},{1145, 121, 377, 633, 889},{1150, 126, 382, 638, 894},{1155, 131, 387, 643, 899},{1160, 136, 392, 648, 904},{1165, 141, 397, 653, 909},{1170, 146, 402, 658, 914},{1175, 151, 407, 663, 919},{1180, 156, 412, 668, 924},{1185, 161, 417, 673, 929},{1190, 166, 422, 678, 934},{1195, 171, 427, 683, 939},{1200, 176, 432, 688, 944},{1205, 181, 437, 693, 949},{1210, 186, 442, 698, 954},{1215, 191, 447, 703, 959},{1220, 196, 452, 708, 964},{1225, 201, 457, 713, 969},{1230, 206, 462, 718, 974},{1235, 211, 467, 723, 979},{1240, 216, 472, 728, 984},{1245, 221, 477, 733, 989},{1250, 226, 482, 738, 994},{1255, 231, 487, 743, 999},{1260, 236, 492, 748, 1004},{1265, 241, 497, 753, 1009},{1270, 246, 502, 758, 1014},{1275, 251, 507, 763, 1019}};
const int crl_1536[512][3] = {{0, 1024, 512},{513, 1, 1025},{1026, 514, 2},{3, 1027, 515},{516, 4, 1028},{1029, 517, 5},{6, 1030, 518},{519, 7, 1031},{1032, 520, 8},{9, 1033, 521},{522, 10, 1034},{1035, 523, 11},{12, 1036, 524},{525, 13, 1037},{1038, 526, 14},{15, 1039, 527},{528, 16, 1040},{1041, 529, 17},{18, 1042, 530},{531, 19, 1043},{1044, 532, 20},{21, 1045, 533},{534, 22, 1046},{1047, 535, 23},{24, 1048, 536},{537, 25, 1049},{1050, 538, 26},{27, 1051, 539},{540, 28, 1052},{1053, 541, 29},{30, 1054, 542},{543, 31, 1055},{1056, 544, 32},{33, 1057, 545},{546, 34, 1058},{1059, 547, 35},{36, 1060, 548},{549, 37, 1061},{1062, 550, 38},{39, 1063, 551},{552, 40, 1064},{1065, 553, 41},{42, 1066, 554},{555, 43, 1067},{1068, 556, 44},{45, 1069, 557},{558, 46, 1070},{1071, 559, 47},{48, 1072, 560},{561, 49, 1073},{1074, 562, 50},{51, 1075, 563},{564, 52, 1076},{1077, 565, 53},{54, 1078, 566},{567, 55, 1079},{1080, 568, 56},{57, 1081, 569},{570, 58, 1082},{1083, 571, 59},{60, 1084, 572},{573, 61, 1085},{1086, 574, 62},{63, 1087, 575},{576, 64, 1088},{1089, 577, 65},{66, 1090, 578},{579, 67, 1091},{1092, 580, 68},{69, 1093, 581},{582, 70, 1094},{1095, 583, 71},{72, 1096, 584},{585, 73, 1097},{1098, 586, 74},{75, 1099, 587},{588, 76, 1100},{1101, 589, 77},{78, 1102, 590},{591, 79, 1103},{1104, 592, 80},{81, 1105, 593},{594, 82, 1106},{1107, 595, 83},{84, 1108, 596},{597, 85, 1109},{1110, 598, 86},{87, 1111, 599},{600, 88, 1112},{1113, 601, 89},{90, 1114, 602},{603, 91, 1115},{1116, 604, 92},{93, 1117, 605},{606, 94, 1118},{1119, 607, 95},{96, 1120, 608},{609, 97, 1121},{1122, 610, 98},{99, 1123, 611},{612, 100, 1124},{1125, 613, 101},{102, 1126, 614},{615, 103, 1127},{1128, 616, 104},{105, 1129, 617},{618, 106, 1130},{1131, 619, 107},{108, 1132, 620},{621, 109, 1133},{1134, 622, 110},{111, 1135, 623},{624, 112, 1136},{1137, 625, 113},{114, 1138, 626},{627, 115, 1139},{1140, 628, 116},{117, 1141, 629},{630, 118, 1142},{1143, 631, 119},{120, 1144, 632},{633, 121, 1145},{1146, 634, 122},{123, 1147, 635},{636, 124, 1148},{1149, 637, 125},{126, 1150, 638},{639, 127, 1151},{1152, 640, 128},{129, 1153, 641},{642, 130, 1154},{1155, 643, 131},{132, 1156, 644},{645, 133, 1157},{1158, 646, 134},{135, 1159, 647},{648, 136, 1160},{1161, 649, 137},{138, 1162, 650},{651, 139, 1163},{1164, 652, 140},{141, 1165, 653},{654, 142, 1166},{1167, 655, 143},{144, 1168, 656},{657, 145, 1169},{1170, 658, 146},{147, 1171, 659},{660, 148, 1172},{1173, 661, 149},{150, 1174, 662},{663, 151, 1175},{1176, 664, 152},{153, 1177, 665},{666, 154, 1178},{1179, 667, 155},{156, 1180, 668},{669, 157, 1181},{1182, 670, 158},{159, 1183, 671},{672, 160, 1184},{1185, 673, 161},{162, 1186, 674},{675, 163, 1187},{1188, 676, 164},{165, 1189, 677},{678, 166, 1190},{1191, 679, 167},{168, 1192, 680},{681, 169, 1193},{1194, 682, 170},{171, 1195, 683},{684, 172, 1196},{1197, 685, 173},{174, 1198, 686},{687, 175, 1199},{1200, 688, 176},{177, 1201, 689},{690, 178, 1202},{1203, 691, 179},{180, 1204, 692},{693, 181, 1205},{1206, 694, 182},{183, 1207, 695},{696, 184, 1208},{1209, 697, 185},{186, 1210, 698},{699, 187, 1211},{1212, 700, 188},{189, 1213, 701},{702, 190, 1214},{1215, 703, 191},{192, 1216, 704},{705, 193, 1217},{1218, 706, 194},{195, 1219, 707},{708, 196, 1220},{1221, 709, 197},{198, 1222, 710},{711, 199, 1223},{1224, 712, 200},{201, 1225, 713},{714, 202, 1226},{1227, 715, 203},{204, 1228, 716},{717, 205, 1229},{1230, 718, 206},{207, 1231, 719},{720, 208, 1232},{1233, 721, 209},{210, 1234, 722},{723, 211, 1235},{1236, 724, 212},{213, 1237, 725},{726, 214, 1238},{1239, 727, 215},{216, 1240, 728},{729, 217, 1241},{1242, 730, 218},{219, 1243, 731},{732, 220, 1244},{1245, 733, 221},{222, 1246, 734},{735, 223, 1247},{1248, 736, 224},{225, 1249, 737},{738, 226, 1250},{1251, 739, 227},{228, 1252, 740},{741, 229, 1253},{1254, 742, 230},{231, 1255, 743},{744, 232, 1256},{1257, 745, 233},{234, 1258, 746},{747, 235, 1259},{1260, 748, 236},{237, 1261, 749},{750, 238, 1262},{1263, 751, 239},{240, 1264, 752},{753, 241, 1265},{1266, 754, 242},{243, 1267, 755},{756, 244, 1268},{1269, 757, 245},{246, 1270, 758},{759, 247, 1271},{1272, 760, 248},{249, 1273, 761},{762, 250, 1274},{1275, 763, 251},{252, 1276, 764},{765, 253, 1277},{1278, 766, 254},{255, 1279, 767},{768, 256, 1280},{1281, 769, 257},{258, 1282, 770},{771, 259, 1283},{1284, 772, 260},{261, 1285, 773},{774, 262, 1286},{1287, 775, 263},{264, 1288, 776},{777, 265, 1289},{1290, 778, 266},{267, 1291, 779},{780, 268, 1292},{1293, 781, 269},{270, 1294, 782},{783, 271, 1295},{1296, 784, 272},{273, 1297, 785},{786, 274, 1298},{1299, 787, 275},{276, 1300, 788},{789, 277, 1301},{1302, 790, 278},{279, 1303, 791},{792, 280, 1304},{1305, 793, 281},{282, 1306, 794},{795, 283, 1307},{1308, 796, 284},{285, 1309, 797},{798, 286, 1310},{1311, 799, 287},{288, 1312, 800},{801, 289, 1313},{1314, 802, 290},{291, 1315, 803},{804, 292, 1316},{1317, 805, 293},{294, 1318, 806},{807, 295, 1319},{1320, 808, 296},{297, 1321, 809},{810, 298, 1322},{1323, 811, 299},{300, 1324, 812},{813, 301, 1325},{1326, 814, 302},{303, 1327, 815},{816, 304, 1328},{1329, 817, 305},{306, 1330, 818},{819, 307, 1331},{1332, 820, 308},{309, 1333, 821},{822, 310, 1334},{1335, 823, 311},{312, 1336, 824},{825, 313, 1337},{1338, 826, 314},{315, 1339, 827},{828, 316, 1340},{1341, 829, 317},{318, 1342, 830},{831, 319, 1343},{1344, 832, 320},{321, 1345, 833},{834, 322, 1346},{1347, 835, 323},{324, 1348, 836},{837, 325, 1349},{1350, 838, 326},{327, 1351, 839},{840, 328, 1352},{1353, 841, 329},{330, 1354, 842},{843, 331, 1355},{1356, 844, 332},{333, 1357, 845},{846, 334, 1358},{1359, 847, 335},{336, 1360, 848},{849, 337, 1361},{1362, 850, 338},{339, 1363, 851},{852, 340, 1364},{1365, 853, 341},{342, 1366, 854},{855, 343, 1367},{1368, 856, 344},{345, 1369, 857},{858, 346, 1370},{1371, 859, 347},{348, 1372, 860},{861, 349, 1373},{1374, 862, 350},{351, 1375, 863},{864, 352, 1376},{1377, 865, 353},{354, 1378, 866},{867, 355, 1379},{1380, 868, 356},{357, 1381, 869},{870, 358, 1382},{1383, 871, 359},{360, 1384, 872},{873, 361, 1385},{1386, 874, 362},{363, 1387, 875},{876, 364, 1388},{1389, 877, 365},{366, 1390, 878},{879, 367, 1391},{1392, 880, 368},{369, 1393, 881},{882, 370, 1394},{1395, 883, 371},{372, 1396, 884},{885, 373, 1397},{1398, 886, 374},{375, 1399, 887},{888, 376, 1400},{1401, 889, 377},{378, 1402, 890},{891, 379, 1403},{1404, 892, 380},{381, 1405, 893},{894, 382, 1406},{1407, 895, 383},{384, 1408, 896},{897, 385, 1409},{1410, 898, 386},{387, 1411, 899},{900, 388, 1412},{1413, 901, 389},{390, 1414, 902},{903, 391, 1415},{1416, 904, 392},{393, 1417, 905},{906, 394, 1418},{1419, 907, 395},{396, 1420, 908},{909, 397, 1421},{1422, 910, 398},{399, 1423, 911},{912, 400, 1424},{1425, 913, 401},{402, 1426, 914},{915, 403, 1427},{1428, 916, 404},{405, 1429, 917},{918, 406, 1430},{1431, 919, 407},{408, 1432, 920},{921, 409, 1433},{1434, 922, 410},{411, 1435, 923},{924, 412, 1436},{1437, 925, 413},{414, 1438, 926},{927, 415, 1439},{1440, 928, 416},{417, 1441, 929},{930, 418, 1442},{1443, 931, 419},{420, 1444, 932},{933, 421, 1445},{1446, 934, 422},{423, 1447, 935},{936, 424, 1448},{1449, 937, 425},{426, 1450, 938},{939, 427, 1451},{1452, 940, 428},{429, 1453, 941},{942, 430, 1454},{1455, 943, 431},{432, 1456, 944},{945, 433, 1457},{1458, 946, 434},{435, 1459, 947},{948, 436, 1460},{1461, 949, 437},{438, 1462, 950},{951, 439, 1463},{1464, 952, 440},{441, 1465, 953},{954, 442, 1466},{1467, 955, 443},{444, 1468, 956},{957, 445, 1469},{1470, 958, 446},{447, 1471, 959},{960, 448, 1472},{1473, 961, 449},{450, 1474, 962},{963, 451, 1475},{1476, 964, 452},{453, 1477, 965},{966, 454, 1478},{1479, 967, 455},{456, 1480, 968},{969, 457, 1481},{1482, 970, 458},{459, 1483, 971},{972, 460, 1484},{1485, 973, 461},{462, 1486, 974},{975, 463, 1487},{1488, 976, 464},{465, 1489, 977},{978, 466, 1490},{1491, 979, 467},{468, 1492, 980},{981, 469, 1493},{1494, 982, 470},{471, 1495, 983},{984, 472, 1496},{1497, 985, 473},{474, 1498, 986},{987, 475, 1499},{1500, 988, 476},{477, 1501, 989},{990, 478, 1502},{1503, 991, 479},{480, 1504, 992},{993, 481, 1505},{1506, 994, 482},{483, 1507, 995},{996, 484, 1508},{1509, 997, 485},{486, 1510, 998},{999, 487, 1511},{1512, 1000, 488},{489, 1513, 1001},{1002, 490, 1514},{1515, 1003, 491},{492, 1516, 1004},{1005, 493, 1517},{1518, 1006, 494},{495, 1519, 1007},{1008, 496, 1520},{1521, 1009, 497},{498, 1522, 1010},{1011, 499, 1523},{1524, 1012, 500},{501, 1525, 1013},{1014, 502, 1526},{1527, 1015, 503},{504, 1528, 1016},{1017, 505, 1529},{1530, 1018, 506},{507, 1531, 1019},{1020, 508, 1532},{1533, 1021, 509},{510, 1534, 1022},{1023, 511, 1535}};
const int goods_1536[512][3] = {{0, 512, 1024},{3, 515, 1027},{6, 518, 1030},{9, 521, 1033},{12, 524, 1036},{15, 527, 1039},{18, 530, 1042},{21, 533, 1045},{24, 536, 1048},{27, 539, 1051},{30, 542, 1054},{33, 545, 1057},{36, 548, 1060},{39, 551, 1063},{42, 554, 1066},{45, 557, 1069},{48, 560, 1072},{51, 563, 1075},{54, 566, 1078},{57, 569, 1081},{60, 572, 1084},{63, 575, 1087},{66, 578, 1090},{69, 581, 1093},{72, 584, 1096},{75, 587, 1099},{78, 590, 1102},{81, 593, 1105},{84, 596, 1108},{87, 599, 1111},{90, 602, 1114},{93, 605, 1117},{96, 608, 1120},{99, 611, 1123},{102, 614, 1126},{105, 617, 1129},{108, 620, 1132},{111, 623, 1135},{114, 626, 1138},{117, 629, 1141},{120, 632, 1144},{123, 635, 1147},{126, 638, 1150},{129, 641, 1153},{132, 644, 1156},{135, 647, 1159},{138, 650, 1162},{141, 653, 1165},{144, 656, 1168},{147, 659, 1171},{150, 662, 1174},{153, 665, 1177},{156, 668, 1180},{159, 671, 1183},{162, 674, 1186},{165, 677, 1189},{168, 680, 1192},{171, 683, 1195},{174, 686, 1198},{177, 689, 1201},{180, 692, 1204},{183, 695, 1207},{186, 698, 1210},{189, 701, 1213},{192, 704, 1216},{195, 707, 1219},{198, 710, 1222},{201, 713, 1225},{204, 716, 1228},{207, 719, 1231},{210, 722, 1234},{213, 725, 1237},{216, 728, 1240},{219, 731, 1243},{222, 734, 1246},{225, 737, 1249},{228, 740, 1252},{231, 743, 1255},{234, 746, 1258},{237, 749, 1261},{240, 752, 1264},{243, 755, 1267},{246, 758, 1270},{249, 761, 1273},{252, 764, 1276},{255, 767, 1279},{258, 770, 1282},{261, 773, 1285},{264, 776, 1288},{267, 779, 1291},{270, 782, 1294},{273, 785, 1297},{276, 788, 1300},{279, 791, 1303},{282, 794, 1306},{285, 797, 1309},{288, 800, 1312},{291, 803, 1315},{294, 806, 1318},{297, 809, 1321},{300, 812, 1324},{303, 815, 1327},{306, 818, 1330},{309, 821, 1333},{312, 824, 1336},{315, 827, 1339},{318, 830, 1342},{321, 833, 1345},{324, 836, 1348},{327, 839, 1351},{330, 842, 1354},{333, 845, 1357},{336, 848, 1360},{339, 851, 1363},{342, 854, 1366},{345, 857, 1369},{348, 860, 1372},{351, 863, 1375},{354, 866, 1378},{357, 869, 1381},{360, 872, 1384},{363, 875, 1387},{366, 878, 1390},{369, 881, 1393},{372, 884, 1396},{375, 887, 1399},{378, 890, 1402},{381, 893, 1405},{384, 896, 1408},{387, 899, 1411},{390, 902, 1414},{393, 905, 1417},{396, 908, 1420},{399, 911, 1423},{402, 914, 1426},{405, 917, 1429},{408, 920, 1432},{411, 923, 1435},{414, 926, 1438},{417, 929, 1441},{420, 932, 1444},{423, 935, 1447},{426, 938, 1450},{429, 941, 1453},{432, 944, 1456},{435, 947, 1459},{438, 950, 1462},{441, 953, 1465},{444, 956, 1468},{447, 959, 1471},{450, 962, 1474},{453, 965, 1477},{456, 968, 1480},{459, 971, 1483},{462, 974, 1486},{465, 977, 1489},{468, 980, 1492},{471, 983, 1495},{474, 986, 1498},{477, 989, 1501},{480, 992, 1504},{483, 995, 1507},{486, 998, 1510},{489, 1001, 1513},{492, 1004, 1516},{495, 1007, 1519},{498, 1010, 1522},{501, 1013, 1525},{504, 1016, 1528},{507, 1019, 1531},{510, 1022, 1534},{513, 1025, 1},{516, 1028, 4},{519, 1031, 7},{522, 1034, 10},{525, 1037, 13},{528, 1040, 16},{531, 1043, 19},{534, 1046, 22},{537, 1049, 25},{540, 1052, 28},{543, 1055, 31},{546, 1058, 34},{549, 1061, 37},{552, 1064, 40},{555, 1067, 43},{558, 1070, 46},{561, 1073, 49},{564, 1076, 52},{567, 1079, 55},{570, 1082, 58},{573, 1085, 61},{576, 1088, 64},{579, 1091, 67},{582, 1094, 70},{585, 1097, 73},{588, 1100, 76},{591, 1103, 79},{594, 1106, 82},{597, 1109, 85},{600, 1112, 88},{603, 1115, 91},{606, 1118, 94},{609, 1121, 97},{612, 1124, 100},{615, 1127, 103},{618, 1130, 106},{621, 1133, 109},{624, 1136, 112},{627, 1139, 115},{630, 1142, 118},{633, 1145, 121},{636, 1148, 124},{639, 1151, 127},{642, 1154, 130},{645, 1157, 133},{648, 1160, 136},{651, 1163, 139},{654, 1166, 142},{657, 1169, 145},{660, 1172, 148},{663, 1175, 151},{666, 1178, 154},{669, 1181, 157},{672, 1184, 160},{675, 1187, 163},{678, 1190, 166},{681, 1193, 169},{684, 1196, 172},{687, 1199, 175},{690, 1202, 178},{693, 1205, 181},{696, 1208, 184},{699, 1211, 187},{702, 1214, 190},{705, 1217, 193},{708, 1220, 196},{711, 1223, 199},{714, 1226, 202},{717, 1229, 205},{720, 1232, 208},{723, 1235, 211},{726, 1238, 214},{729, 1241, 217},{732, 1244, 220},{735, 1247, 223},{738, 1250, 226},{741, 1253, 229},{744, 1256, 232},{747, 1259, 235},{750, 1262, 238},{753, 1265, 241},{756, 1268, 244},{759, 1271, 247},{762, 1274, 250},{765, 1277, 253},{768, 1280, 256},{771, 1283, 259},{774, 1286, 262},{777, 1289, 265},{780, 1292, 268},{783, 1295, 271},{786, 1298, 274},{789, 1301, 277},{792, 1304, 280},{795, 1307, 283},{798, 1310, 286},{801, 1313, 289},{804, 1316, 292},{807, 1319, 295},{810, 1322, 298},{813, 1325, 301},{816, 1328, 304},{819, 1331, 307},{822, 1334, 310},{825, 1337, 313},{828, 1340, 316},{831, 1343, 319},{834, 1346, 322},{837, 1349, 325},{840, 1352, 328},{843, 1355, 331},{846, 1358, 334},{849, 1361, 337},{852, 1364, 340},{855, 1367, 343},{858, 1370, 346},{861, 1373, 349},{864, 1376, 352},{867, 1379, 355},{870, 1382, 358},{873, 1385, 361},{876, 1388, 364},{879, 1391, 367},{882, 1394, 370},{885, 1397, 373},{888, 1400, 376},{891, 1403, 379},{894, 1406, 382},{897, 1409, 385},{900, 1412, 388},{903, 1415, 391},{906, 1418, 394},{909, 1421, 397},{912, 1424, 400},{915, 1427, 403},{918, 1430, 406},{921, 1433, 409},{924, 1436, 412},{927, 1439, 415},{930, 1442, 418},{933, 1445, 421},{936, 1448, 424},{939, 1451, 427},{942, 1454, 430},{945, 1457, 433},{948, 1460, 436},{951, 1463, 439},{954, 1466, 442},{957, 1469, 445},{960, 1472, 448},{963, 1475, 451},{966, 1478, 454},{969, 1481, 457},{972, 1484, 460},{975, 1487, 463},{978, 1490, 466},{981, 1493, 469},{984, 1496, 472},{987, 1499, 475},{990, 1502, 478},{993, 1505, 481},{996, 1508, 484},{999, 1511, 487},{1002, 1514, 490},{1005, 1517, 493},{1008, 1520, 496},{1011, 1523, 499},{1014, 1526, 502},{1017, 1529, 505},{1020, 1532, 508},{1023, 1535, 511},{1026, 2, 514},{1029, 5, 517},{1032, 8, 520},{1035, 11, 523},{1038, 14, 526},{1041, 17, 529},{1044, 20, 532},{1047, 23, 535},{1050, 26, 538},{1053, 29, 541},{1056, 32, 544},{1059, 35, 547},{1062, 38, 550},{1065, 41, 553},{1068, 44, 556},{1071, 47, 559},{1074, 50, 562},{1077, 53, 565},{1080, 56, 568},{1083, 59, 571},{1086, 62, 574},{1089, 65, 577},{1092, 68, 580},{1095, 71, 583},{1098, 74, 586},{1101, 77, 589},{1104, 80, 592},{1107, 83, 595},{1110, 86, 598},{1113, 89, 601},{1116, 92, 604},{1119, 95, 607},{1122, 98, 610},{1125, 101, 613},{1128, 104, 616},{1131, 107, 619},{1134, 110, 622},{1137, 113, 625},{1140, 116, 628},{1143, 119, 631},{1146, 122, 634},{1149, 125, 637},{1152, 128, 640},{1155, 131, 643},{1158, 134, 646},{1161, 137, 649},{1164, 140, 652},{1167, 143, 655},{1170, 146, 658},{1173, 149, 661},{1176, 152, 664},{1179, 155, 667},{1182, 158, 670},{1185, 161, 673},{1188, 164, 676},{1191, 167, 679},{1194, 170, 682},{1197, 173, 685},{1200, 176, 688},{1203, 179, 691},{1206, 182, 694},{1209, 185, 697},{1212, 188, 700},{1215, 191, 703},{1218, 194, 706},{1221, 197, 709},{1224, 200, 712},{1227, 203, 715},{1230, 206, 718},{1233, 209, 721},{1236, 212, 724},{1239, 215, 727},{1242, 218, 730},{1245, 221, 733},{1248, 224, 736},{1251, 227, 739},{1254, 230, 742},{1257, 233, 745},{1260, 236, 748},{1263, 239, 751},{1266, 242, 754},{1269, 245, 757},{1272, 248, 760},{1275, 251, 763},{1278, 254, 766},{1281, 257, 769},{1284, 260, 772},{1287, 263, 775},{1290, 266, 778},{1293, 269, 781},{1296, 272, 784},{1299, 275, 787},{1302, 278, 790},{1305, 281, 793},{1308, 284, 796},{1311, 287, 799},{1314, 290, 802},{1317, 293, 805},{1320, 296, 808},{1323, 299, 811},{1326, 302, 814},{1329, 305, 817},{1332, 308, 820},{1335, 311, 823},{1338, 314, 826},{1341, 317, 829},{1344, 320, 832},{1347, 323, 835},{1350, 326, 838},{1353, 329, 841},{1356, 332, 844},{1359, 335, 847},{1362, 338, 850},{1365, 341, 853},{1368, 344, 856},{1371, 347, 859},{1374, 350, 862},{1377, 353, 865},{1380, 356, 868},{1383, 359, 871},{1386, 362, 874},{1389, 365, 877},{1392, 368, 880},{1395, 371, 883},{1398, 374, 886},{1401, 377, 889},{1404, 380, 892},{1407, 383, 895},{1410, 386, 898},{1413, 389, 901},{1416, 392, 904},{1419, 395, 907},{1422, 398, 910},{1425, 401, 913},{1428, 404, 916},{1431, 407, 919},{1434, 410, 922},{1437, 413, 925},{1440, 416, 928},{1443, 419, 931},{1446, 422, 934},{1449, 425, 937},{1452, 428, 940},{1455, 431, 943},{1458, 434, 946},{1461, 437, 949},{1464, 440, 952},{1467, 443, 955},{1470, 446, 958},{1473, 449, 961},{1476, 452, 964},{1479, 455, 967},{1482, 458, 970},{1485, 461, 973},{1488, 464, 976},{1491, 467, 979},{1494, 470, 982},{1497, 473, 985},{1500, 476, 988},{1503, 479, 991},{1506, 482, 994},{1509, 485, 997},{1512, 488, 1000},{1515, 491, 1003},{1518, 494, 1006},{1521, 497, 1009},{1524, 500, 1012},{1527, 503, 1015},{1530, 506, 1018},{1533, 509, 1021}};

void initparam()
{
	param_pairs[8] = calc_param(2, 4);
	param_pairs[16] = calc_param(2, 8);
	param_pairs[32] = calc_param(4, 8);
	param_pairs[64] = calc_param(8, 8);
	param_pairs[128] = calc_param(2, 64);
	param_pairs[256] = calc_param(4, 64);
	param_pairs[512] = calc_param(8, 64);
	param_pairs[1024] = calc_param(16, 64);
	param_pairs[2048] = calc_param(32, 64);
	param_pairs[1280] = calc_param(256, 5);
	param_pairs[1536] = calc_param(512, 3);

	// check the correctness of the lookup table
	//	for (int k1 = 0; k1 < 256; k1++)
	//	{
	//		for (int k2 = 0; k2 < 5; k2++)
	//		{
	//			assert(crl_1280[k1][k2] == (256 * k2 + 1025 * k1) % 1280);
	//			assert(goods_1280[k1][k2] == (256 * k2 + 5 * k1) % 1280);
	//		}
	//	}
	//
	//	for (int k1 = 0; k1 < 512; k1++)
	//	{
	//		for (int k2 = 0; k2 < 3; k2++)
	//		{
	//			assert(crl_1536[k1][k2] == (1024 * k2 + 513 * k1) % 1536);
	//			assert(goods_1536[k1][k2] == (512 * k2 + 3 * k1) % 1536);
	//		}
	//	}
}

void releaseparam()
{
	for (map<int, param>::iterator itr = param_pairs.begin(); itr != param_pairs.end(); ++itr)
	{
		delete[] itr->second.index;
		delete[] itr->second.w;
	}
}

//fstream f = fstream("inner.txt", ios::out);
void fft2(complex const din[], complex dout[])
{
	dout[0] = complexadd(din[0], din[1]);
	dout[1] = complexsub(din[0], din[1]);
};

void fft3(complex const din[], complex dout[])
{
	complex t31 = complexadd(din[1], din[2]);
	complex t32 = complexsub(din[2], din[1]);

	complex m31 = complexadd(din[0], t31);

	complex m32{arith_rshift(t31.real, 1, WIDTH), arith_rshift(t31.imag, 1, WIDTH)};
	m32 = complexadd(m32, t31);
	m32 = complexsub(complex{0, 0}, m32);

	complex m33 = complex{serial_subtractor(0, mul(t32.imag, 454047, WIDTH, MULTYPE), WIDTH), mul(t32.real, 454047, WIDTH, MULTYPE)};

	complex s31 = complexadd(m31, m32);

	dout[0] = m31;
	dout[1] = complexadd(s31, m33);
	dout[2] = complexsub(s31, m33);
}

void fft4(complex const din[], complex dout[])
{
	complex left_outputs[2][2];
	complex right_inputs[2][2];
	complex right_outputs[2][2];
	complex left_tmp[2];

	// left fft
	for (int i = 0; i < 2; i++)
	{
		pickarray(din, left_tmp, i, 2, 4);
		fft2(left_tmp, left_outputs[i]);
	}

	// transpose, right_inputs = left_outputs.'
	for (int i = 0; i < 2; i++)
	{
		for (int j = 0; j < 2; j++)
		{
			right_inputs[i][j].real = left_outputs[j][i].real;
			right_inputs[i][j].imag = left_outputs[j][i].imag;
		}
	}
	// adjust twiddle factor
	right_inputs[1][1].real = left_outputs[1][1].imag;
	right_inputs[1][1].imag = serial_subtractor(0, left_outputs[1][1].real, WIDTH);

	// right fft
	for (int j = 0; j < 2; j++)
	{
		fft2(right_inputs[j], right_outputs[j]);
	}

	// transpose, output = right_outputs(:)
	for (int i = 0; i < 2; i++)
	{
		for (int j = 0; j < 2; j++)
		{
			dout[i * 2 + j].real = arith_rshift(right_outputs[j][i].real, 1, WIDTH);
			dout[i * 2 + j].imag = arith_rshift(right_outputs[j][i].imag, 1, WIDTH);
		}
	}
}

void fft5(complex const din[], complex dout[])
{
	complex t51 = complexadd(din[1], din[4]);
	complex t52 = complexadd(din[2], din[3]);
	complex t53 = complexsub(din[1], din[4]);
	complex t54 = complexsub(din[3], din[2]);
	complex t55 = complexadd(t51, t52);
	complex t56 = complexsub(t51, t52);
	complex t57 = complexadd(t53, t54);

	complex m51 = complexadd(din[0], t55);

	complex m52{arith_rshift(t55.real, 2, WIDTH), arith_rshift(t55.imag, 2, WIDTH)};
	m52 = complexadd(m52, t55);
	m52 = complexsub(complex{0, 0}, m52);

	complex m53{mul(t56.real, 293086, WIDTH, MULTYPE), mul(t56.imag, 293086, WIDTH, MULTYPE)};
	complex m54{serial_subtractor(0, mul(t57.imag, 498628, WIDTH, MULTYPE), WIDTH), mul(t57.real, 498628, WIDTH, MULTYPE)};
	complex m55{mul(t54.imag, 403398, WIDTH, MULTYPE) << 1, serial_subtractor(0, mul(t54.real, 403398, WIDTH, MULTYPE), WIDTH) << 1};
	complex m56{mul(t53.imag, 190459, WIDTH, MULTYPE), serial_subtractor(0, mul(t53.real, 190459, WIDTH, MULTYPE), WIDTH)};

	complex s51 = complexadd(m51, m52);
	complex s52 = complexadd(s51, m53);
	complex s53 = complexadd(m54, m55);
	complex s54 = complexsub(s51, m53);
	complex s55 = complexadd(m54, m56);

	dout[0] = m51;
	dout[1] = complexsub(s52, s53);
	dout[2] = complexsub(s54, s55);
	dout[3] = complexadd(s54, s55);
	dout[4] = complexadd(s52, s53);
}

void fft8(complex const din[], complex dout[])
{
	param p = param_pairs.find(8)->second;
	fftx(din, dout, fft2, 2, p.index, p.w, fft4, 4);
}

void fft16(complex const din[], complex dout[])
{
	param p = param_pairs.find(16)->second;
	fftx(din, dout, fft2, 2, p.index, p.w, fft8, 8);
}

void fft32(complex const din[], complex dout[])
{
	param p = param_pairs.find(32)->second;
	fftx(din, dout, fft4, 4, p.index, p.w, fft8, 8);
}

void fft64(complex const din[], complex dout[])
{
	param p = param_pairs.find(64)->second;
	fftx(din, dout, fft8, 8, p.index, p.w, fft8, 8);
}

void fft128(complex const din[], complex dout[])
{
	param p = param_pairs.find(128)->second;
	fftx(din, dout, fft2, 2, p.index, p.w, fft64, 64);
}

void fft256(complex const din[], complex dout[])
{
	param p = param_pairs.find(256)->second;
	fftx(din, dout, fft4, 4, p.index, p.w, fft64, 64);
}

void fft512(complex const din[], complex dout[])
{
	param p = param_pairs.find(512)->second;
	fftx(din, dout, fft8, 8, p.index, p.w, fft64, 64);
}

void fft1024(complex const din[], complex dout[])
{
	param p = param_pairs.find(1024)->second;
	fftx(din, dout, fft16, 16, p.index, p.w, fft64, 64);
}

void fft2048(complex const din[], complex dout[])
{
	param p = param_pairs.find(2048)->second;
	fftx(din, dout, fft32, 32, p.index, p.w, fft64, 64);
}

void fft1280(const complex din[], complex dout[])
{
	// twiddle factor is 1
	complex w[1280];
	for (int i = 0; i < 1280; i++)
	{
		w[i].real = 1 << (WIDTH - 1);
		w[i].imag = 0;
	}

	complex* din_reordered = new complex[1280];
	complex* dout_messed = new complex[1280];

	// reorder for input
	for (int i = 0; i < 256; i++)
	{
		for (int j = 0; j < 5; j++)
		{
			din_reordered[i * 5 + j] = din[goods_1280[i][j]];
		}
	}

	// fft
	fftx(din_reordered, dout_messed, fft256, 256, NULL, w, fft5, 5);

	// reorder for output
	for (int i = 0; i < 5; i++)
	{
		for (int j = 0; j < 256; j++)
		{
			dout[crl_1280[j][i]] = dout_messed[i * 256 + j];
		}
	}

	delete[] din_reordered;
	delete[] dout_messed;
}

void fft1536(const complex din[], complex dout[])
{
	// twiddle factor is 1
	complex w[1536];
	for (int i = 0; i < 1536; i++)
	{
		w[i].real = 1 << (WIDTH - 1);
		w[i].imag = 0;
	}

	complex* din_reordered = new complex[1536];
	complex* dout_messed = new complex[1536];

	// reorder for input
	for (int i = 0; i < 512; i++)
	{
		for (int j = 0; j < 3; j++)
		{
			din_reordered[i * 3 + j] = din[goods_1536[i][j]];
		}
	}

	// fft
	fftx(din_reordered, dout_messed, fft512, 512, NULL, w, fft3, 3);

	// reorder for output
	for (int i = 0; i < 3; i++)
	{
		for (int j = 0; j < 512; j++)
		{
			dout[crl_1536[j][i]] = dout_messed[i * 512 + j];
		}
	}

	delete[] din_reordered;
	delete[] dout_messed;
}

void fftx(complex const din[], complex dout[], fftx_func lfft, int m, int* index, complex* w, fftx_func rfft, int n)
{
	int pt = m * n;

	// allocate memory for variables
	complex** left_outputs = new complex*[n];
	complex** right_inputs = new complex*[m];
	complex** right_outputs = new complex*[m];
	complex* left_tmp = new complex[m];

	left_outputs[0] = new complex[pt];
	right_inputs[0] = new complex[pt];
	right_outputs[0] = new complex[pt];
	for (int i = 1; i < n; i++)
	{
		left_outputs[i] = left_outputs[0] + i * m;
	}
	for (int i = 0; i < m; i++)
	{
		right_inputs[i] = right_inputs[0] + i * n;
		right_outputs[i] = right_outputs[0] + i * n;
	}

	// left fft
	for (int i = 0; i < n; i++)
	{
		pickarray(din, left_tmp, i, n, pt);
		(*lfft)(left_tmp, left_outputs[i]);
	}

	// transpose, right_inputs = (left_outputs.').*w
	for (int i = 0; i < m; i++)
	{
		for (int j = 0; j < n; j++)
		{
			right_inputs[i][j] = complexmul(left_outputs[j][i], w[i * n + j], WIDTH, MULTYPE);
		}
	}

	// right fft
	for (int j = 0; j < m; j++)
	{
		(*rfft)(right_inputs[j], right_outputs[j]);
	}

	// transpose, output = right_outputs(:)
	for (int i = 0; i < n; i++)
	{
		for (int j = 0; j < m; j++)
		{
			dout[i * m + j] = right_outputs[j][i];
		}
	}

	delete[] left_outputs[0];
	delete[] right_inputs[0];
	delete[] right_outputs[0];
	delete[] left_outputs;
	delete[] right_inputs;
	delete[] right_outputs;
	delete[] left_tmp;
}

