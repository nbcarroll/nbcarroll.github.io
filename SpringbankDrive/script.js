function calculateCompensation() {
  // Get input values
  const frontageInput = document.getElementById('frontage-input');
  const fourLaneInput = document.getElementById('four-lane-input');

  const frontageLost = parseFloat(frontageInput.value);
  const isOnFourLane = parseFloat(fourLaneInput.value);

  // Perform calculation
  const lumpSum = 12000;
  const frontageCoeff = 38.55;
  const onFourLaneCoeff = 7967;

  const compensation = lumpSum + (frontageCoeff * frontageLost) + (onFourLaneCoeff * isOnFourLane);

  // Display result
  const resultContainer = document.getElementById('result-container');
  const resultElement = document.getElementById('compensation-result');

  resultElement.textContent = `$${compensation.toFixed(2)}`;
  resultContainer.style.display = 'block';
}
