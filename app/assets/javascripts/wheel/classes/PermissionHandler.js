var PermissionHandler = function() {

    this.userTypes = {
        names: []
    };
    this.clearance = [];
    this.permissions = [];
    this.codes = [];

    this.createPermissions(PermissionHandler.getDefault('permissions'));

};

// Adds user-types to PermissionHandler.userTypes.names via an array
PermissionHandler.prototype.addUserTypes = function(arr) {
    if (!(arr instanceof Array)) throw new Error('The parameter in PermissionHandler.addUserTypes(arr) must be an array');
    
    this.userTypes.names = this.userTypes.names.concat(arr);

    for (var i = 0, child; child = arr[i++];) {
        this.userTypes[child] = {};
        for (var p = 0, permission; permission = this.permissions[p++];) {
            this.userTypes[child][permission.toFnName()] = this.check.bind(this, permission, child);
        }
    }

    return this;
}
// Adds clearance-levels to PermissionHandler.clearance via an array
PermissionHandler.prototype.addClearance = function(arr) {
    if (!(arr instanceof Array)) throw new Error('The parameter in PermissionHandler.addClearance(arr) must be an array');

    this.clearance = this.clearance.concat(arr);
    return this;
}
// Adds permission-types to PermissionHandler.permissions via an array
PermissionHandler.prototype.createPermissions = function(arr) {
    if (!(arr instanceof Array)) throw new Error('The parameter in PermissionHandler.addPermissions(arr) must be an array');

    this.permissions = this.permissions.concat(arr);

    for (var i = 0, permission; permission = arr[i++];) {
        for (var p = 0, child; child = this.userTypes.names[p++];) {
            this.userTypes[child][permission.toFnName()] = this.check.bind(this, permission, child);
        }
    }

    return this;

    // permissions.userType['admin'].canEdit('admin');
}

PermissionHandler.prototype.userType = function(userType) {
    return this.userTypes[userType];
}

/* Insert an array in this format to set permissions.
[
    'admin can-edit admin',
    'admin can-edit juror',
    'admin can-view principal',
    'admin can-view juror',
]
*/
PermissionHandler.prototype.set = function(data) {
    if (!(data instanceof Array)) throw new Error('The parameter in PermissionHandler.set(data) must be an array');

    var _this = this;

    for (var i = 0, p; p = data[i++];) {
        var arr = p.split(" "),
            userType = arr[0],
            permissionName = arr[1],
            clearanceName = arr[2];

        _this.checkParams(userType, permissionName, clearanceName);

        _this.codes.push([
            _this.userTypes.names.indexOf(userType),
            _this.permissions.indexOf(permissionName),
            _this.clearance.indexOf(clearanceName),
        ]);
    }
}

PermissionHandler.prototype.checkParams = function (userType, permission, clearance) {
    if (!this.userTypes.names.contains(userType)) throw new Error('No usertype called "' + userType + '" exists in object PermissionHandler.\n Add it with PermissionHandler.addUserTypes(arr).');
    if (!this.permissions.contains(permission)) throw new Error('No permission-type called "' + permission + '" exists in object PermissionHandler.\n Add it with PermissionHandler.addPermissions(arr).');
    if (!this.clearance.contains(clearance)) throw new Error('No clearance called "' + clearance + '" exists in object PermissionHandler.\n Add it with PermissionHandler.addclearance(arr).');
    return this;
}

PermissionHandler.prototype.check = function(permission, currentUserType, clearanceName) {
    var _this = this;
    _this.checkParams(currentUserType, permission, clearanceName);

    var codes = [
        _this.userTypes.names.indexOf(currentUserType),
        _this.permissions.indexOf(permission),
        _this.clearance.indexOf(clearanceName)
    ];

    for (var i = 0, c; c = _this.codes[i++];) {
        if (c[0] === codes[0] && c[1] === codes[1] && c[2] === codes[2]) return true;
    }

    return false
}

// // Returns true if the 'currentUserType' can edit events 
// // at the specified 'clearance'-level
// Permission.canEdit = Permission.check.bind(null, 'can-edit')

// // Returns true if the 'currentUserType' can view events 
// // at the specified 'clearance'-level.
// Permission.canView = function(currentUserType, clearanceName) {
//     if (Permission.canEdit(currentUserType, clearanceName)) return true;

//     return Permission.check('can-view', currentUserType, clearanceName)
// }


PermissionHandler.getDefault = function(name) {
    return PermissionHandler['DEFAULT_' + name.toUpperCase()];
}

PermissionHandler.setDefaults = function() {
    PermissionHandler.DEFAULT_PERMISSIONS = ['can-edit', 'can-view'];
}    