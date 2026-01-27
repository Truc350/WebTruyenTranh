
    function initSlider(slider) {
    const track = slider.querySelector('.slider-track');
    const viewport = slider.querySelector('.slider-viewport');
    const prevBtn = slider.querySelector('.arrow.prev');
    const nextBtn = slider.querySelector('.arrow.next');
    const items = slider.querySelectorAll('.product-item');

    if (!items.length) {
    console.log('No items found in slider');
    return;
}

    let currentPosition = 0;

    function getScrollAmount() {
    const itemWidth = items[0].offsetWidth;
    const gap = 15; // gap giữa các items
    const itemsToScroll = 3; // Số items muốn cuộn mỗi lần
    return (itemWidth + gap) * itemsToScroll;
}

    function getMaxScroll() {
    const trackWidth = track.scrollWidth;
    const viewportWidth = viewport.offsetWidth;
    return Math.max(0, trackWidth - viewportWidth);
}

    function updatePosition() {
    track.style.transform = `translateX(-${currentPosition}px)`;
    updateButtons();
}

    function updateButtons() {
    const maxScroll = getMaxScroll();

    // Disable/enable buttons
    if (currentPosition <= 0) {
    prevBtn.disabled = true;
    prevBtn.style.opacity = '0.3';
} else {
    prevBtn.disabled = false;
    prevBtn.style.opacity = '1';
}

    if (currentPosition >= maxScroll) {
    nextBtn.disabled = true;
    nextBtn.style.opacity = '0.3';
} else {
    nextBtn.disabled = false;
    nextBtn.style.opacity = '1';
}
}

    // Click next
    nextBtn.addEventListener('click', function(e) {
    e.preventDefault();
    const scrollAmount = getScrollAmount();
    const maxScroll = getMaxScroll();

    currentPosition = Math.min(currentPosition + scrollAmount, maxScroll);
    updatePosition();
});

    // Click prev
    prevBtn.addEventListener('click', function(e) {
    e.preventDefault();
    const scrollAmount = getScrollAmount();

    currentPosition = Math.max(currentPosition - scrollAmount, 0);
    updatePosition();
});

    // Initial state
    updateButtons();

    // Update on window resize
    let resizeTimeout;
    window.addEventListener('resize', function() {
    clearTimeout(resizeTimeout);
    resizeTimeout = setTimeout(function() {
    const maxScroll = getMaxScroll();
    if (currentPosition > maxScroll) {
    currentPosition = maxScroll;
    updatePosition();
}
    updateButtons();
}, 250);
});
}

    // Initialize all sliders when DOM is ready
    document.addEventListener('DOMContentLoaded', function() {
    console.log('Initializing sliders...');
    const sliders = document.querySelectorAll('.product-slider');
    console.log('Found ' + sliders.length + ' sliders');
    sliders.forEach(function(slider, index) {
    console.log('Initializing slider ' + index);
    initSlider(slider);
});
});

    // Check if jQuery is causing conflicts
    console.log('Page loaded');
    console.log('Sliders found:', document.querySelectorAll('.product-slider').length);
    console.log('Items found:', document.querySelectorAll('.product-item').length);

