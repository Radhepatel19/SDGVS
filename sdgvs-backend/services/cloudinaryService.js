const cloudinary = require('cloudinary').v2;
const streamifier = require('streamifier');

// Cloudinary will automatically pick up the CLOUDINARY_URL environment variable
/**
 * Uploads a file buffer to Cloudinary using streams.
 * @param {Buffer} buffer - The file buffer.
 * @param {String} folder - The Cloudinary folder to upload to.
 * @param {String} resourceType - 'auto', 'image', 'video', 'raw'.
 * @returns {Promise<Object>} - The Cloudinary upload response.
 */
exports.uploadStream = (buffer, folder = 'sdgvs_uploads', resourceType = 'auto') => {
  return new Promise((resolve, reject) => {
    const uploadStream = cloudinary.uploader.upload_stream(
      {
        folder: folder,
        resource_type: resourceType,
      },
      (error, result) => {
        if (error) {
          reject(error);
        } else {
          resolve(result);
        }
      }
    );

    // Write the buffer to the stream and end it
    streamifier.createReadStream(buffer).pipe(uploadStream);
  });
};
