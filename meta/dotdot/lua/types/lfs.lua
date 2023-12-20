---@meta

---@class lfs
local lfs = {}

---@alias LfsAttributeKeys
---| "access"
---| "blksize"
---| "blocks"
---| "change"
---| "dev"
---| "gid"
---| "ino"
---| "mode"
---| "modification"
---| "nlink"
---| "permissions"
---| "rdev"
---| "size"
---| "uid"

---@class LfsAttributes
---@field dev integer on Unix systems, this represents the device that the inode resides on. On Windows systems, represents the drive number of the disk containing the file
---@field ino string on Unix systems, this represents the inode number. On Windows systems this has no meaning
---@field mode string string representing the associated protection mode (the values could be file, directory, link, socket, named pipe, char device, block device or other)
---@field nlink integer number of hard links to the file
---@field uid integer user-id of owner (Unix only, always 0 on Windows)
---@field gid integer group-id of owner (Unix only, always 0 on Windows)
---@field rdev integer on Unix systems, represents the device type, for special file inodes. On Windows systems represents the same as dev
---@field access integer time of last access
---@field modification integer time of last data modification
---@field change integer time of last file status change
---@field size integer file size, in bytes
---@field permissions string file permissions string
---@field blocks integer block allocated for file; (Unix only)
---@field blksize integer optimal file system I/O blocksize; (Unix only)
lfs.LfsAttributes = {}

---@alias LfsSymlinkAttributeKeys
---| "access"
---| "blksize"
---| "blocks"
---| "change"
---| "dev"
---| "gid"
---| "ino"
---| "mode"
---| "modification"
---| "nlink"
---| "permissions"
---| "rdev"
---| "size"
---| "target"
---| "uid"

---@class LfsSymlinkAttributes: LfsAttributes
---@field target string
lfs.LfsSymlinkAttributes = {}

-- ------------------------------------------------------------------------
-- | LFS Lock
-- ------------------------------------------------------------------------

---@class LfsLock
lfs.LfsLock = {}

---@param self LfsLock
function lfs.LfsLock.free(self) end

-- ------------------------------------------------------------------------
-- | LFS Directory Iterator
-- ------------------------------------------------------------------------

---@class LfsDirectoryObject
lfs.LfsDirectoryObject = {}

---@class LfsDirectoryIterator: Iter
lfs.LfsDirectoryIterator = {}

---Get the next item from the iterator.
---@param self LfsDirectoryIterator
---@param dir_obj LfsDirectoryObject
function lfs.LfsDirectoryIterator.next(self, dir_obj) end

---Close the iterator.
---@param self LfsDirectoryIterator
function lfs.LfsDirectoryIterator.close(self) end

-- ------------------------------------------------------------------------
-- | LFS Module
-- ------------------------------------------------------------------------

---@param filename string
---@param table table?
function lfs.attributes(filename, table) end

---@param filename string
---@param table table?
---@return nil, string, integer
function lfs.attributes(filename, table) end

---@param filename string
---@param key LfsAttributeKeys
---@return any value
function lfs.attributes(filename, key) end

---@param filename string
---@param key LfsAttributeKeys
---@return nil, string, integer error
function lfs.attributes(filename, key) end

---@param path string
---@return true succeeded
function lfs.chdir(path) end

---@return nil, string error Returns an error message.
function lfs.chdir(path) end

---@param dirname string
---@param seconds_stale integer
---@return LfsLock
function lfs.lock_dir(dirname, seconds_stale) end

---@return nil, "File exists" | string error Returns a "File exists" message if the lock exists and is not stale.
function lfs.lock_dir(dirname, seconds_stale) end

---@return string cwd Returns the current working directory.
function lfs.current_dir() end

---@return nil, string error Returns the error message.
function lfs.current_dir() end

---Lua iterator over the entries of a given directory. Each time the iterator is
---called with dir_obj, it returns a directory entry's name as a string, or nil
---if there are no more entries. You can also iterate by calling dir_obj:next(),
---and explicitly close the directory before the iteration is finished with
---dir_obj:close()
---@param dirname string
---@return LfsDirectoryIterator, LfsDirectoryObject
function lfs.dir(dirname) end

---Locks a file or part of it. This function works on open files.
---@param filehandle string
---@param mode "r" | "w" "r" creates a read, or a shared, lock. "w" creates a write, or an exclusive, lock.
---@param start integer? Optional start line in the file.
---@param length integer? Optional number of lines to lock in the file.
---@return true succeeded Returns true if the operation was successful. In case of an error, it returns nil plus an error string.
function lfs.lock(filehandle, mode, start, length) end

---@return nil error Returns true if the operation was successful. In case of an error, it returns nil plus an error string.
function lfs.lock(filehandle, mode, start, length) end

---Creates a link.
---@param source string The object to link.
---@param target string The name of the link.
---@param symlink boolean Set to true to create a symbolic link.
function lfs.link(source, target, symlink) end

---Creates a new directory.
---@param dirname string
---@return true succeeded Returns true in case of success or nil, an error message and a system-dependent error code in case of an error.
function lfs.mkdir(dirname) end

---@return nil, string, integer error Returns true in case of success or nil, an error message and a system-dependent error code in case of an error.
function lfs.mkdir(dirname) end

---Removes an existing directory. The argument is the name of the directory.
---@param dirname string
---@return true succeeded Returns true in case of success or nil, an error message and a system-dependent error code in case of error.
function lfs.rmdir(dirname) end

---@return nil, string, integer error Returns true in case of success or nil, an error message and a system-dependent error code in case of error.
function lfs.rmdir(dirname) end

---Sets the writing mode for a file. On non-Windows platforms, where the two
---modes are identical, setting the mode has no effect, and the mode is always
---returned as binary.
---@param filepath string
---@param mode "binary" | "text"
---@return true, "binary" | "text" succeeded Returns true followed the previous mode string for the file, or nil followed by an error string in case of errors.
function lfs.setmode(filepath, mode) end

---@return nil, string error Returns true followed the previous mode string for the file, or nil followed by an error string in case of errors.
function lfs.setmode(filepath, mode) end

---Identical to lfs.attributes except that it obtains information about the link
---itself (not the file it refers to). It also adds a target field, containing
---the file name that the symlink points to. On Windows this function does not
---yet support links, and is identical to lfs.attributes.
---@param filepath string
---@return LfsSymlinkAttributes
function lfs.symlinkattributes(filepath) end

---@param filepath string
---@param key LfsSymlinkAttributeKeys
---@return integer | string
function lfs.symlinkattributes(filepath, key) end

---@return nil, string, integer error Returns a table with the file attributes
function lfs.symlinkattributes(...) end

---Set access and modification times of a file. This function is a bind to utime
---function.
---@param filepath string
---@param atime string access time in seconds since unix epoch.
---@param mtime string modification time in seconds since unix epoch.
---@return true succeeded Returns true in case of success or nil, an error message and a system-dependent error code in case of error.
function lfs.touch(filepath, atime, mtime) end

---@return nil, string, integer error Returns true in case of success or nil, an error message and a system-dependent error code in case of error.
function lfs.touch(filepath, atime, mtime) end

---Unlocks a file or a part of it. This function works on open files.
---@param filehandle string
---@param start integer?
---@param length integer?
---@return true succeeded Returns true if the operation was successful. In case of an error, it returns nil plus an error string.
function lfs.unlock(filehandle, start, length) end

---@return nil, string error Returns true if the operation was successful. In case of an error, it returns nil plus an error string.
function lfs.unlock(filehandle, start, length) end
