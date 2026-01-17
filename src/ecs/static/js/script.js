// Initialize on page load
document.addEventListener('DOMContentLoaded', function() {
    console.log('ECS Static Website loaded successfully');
    
    // Display current time (optional feature)
    displayCurrentTime();
});

// Function to display current time
function displayCurrentTime() {
    const now = new Date();
    const timeString = now.toLocaleString('ja-JP', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit'
    });
    
    console.log('Current time:', timeString);
}

// Function for future feature enhancements
function initializeApp() {
    // Add application initialization logic here
}
