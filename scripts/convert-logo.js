const fs = require('node:fs');
const sharp = require('sharp');
const path = require('node:path');
const ASSETS_DIR = path.join(__dirname, "..", "public", "assets");

// Sizes for different use cases
const sizes = [16, 32, 48, 64, 128, 192, 256, 512];

async function convertLogoToPng() {
    console.log("Generating logo files...");
    // Create assets directory if it doesn't exist
    if (!fs.existsSync(ASSETS_DIR)) {
        fs.mkdirSync(ASSETS_DIR);
    }

    const inputFile = path.join(ASSETS_DIR, 'favicon.svg');
    
    for (const size of sizes) {
        await sharp(inputFile)
            .resize(size, size)
            .png()
            .toFile(path.join(ASSETS_DIR, `logo-${size}.png`));
        
        console.log(`Created ${size}x${size} PNG`);
    }
    
    // Create favicon.ico size
    await sharp(inputFile)
        .resize(32, 32)
        .png()
        .toFile(path.join(ASSETS_DIR, 'favicon.png'));
    
    console.log('Conversion complete!');
}

module.exports = { convertLogoToPng };