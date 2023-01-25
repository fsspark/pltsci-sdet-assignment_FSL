Feature: Hoover Navigation Validation


#Happy Path
  Scenario Outline: Validate patches and coords are properly calculated for different roomSize and same coords and patches
    Given url 'http://localhost:8080/v1/cleaning-sessions'
    And request {"roomSize" : <roomSize>, "coords" : [1,2], "patches" : [[1,0],[2,2],[2,3]], "instructions" : "NNESEESWNWW"}
    When method POST
    Then status 200
    And match $.coords == [1,3]
    And match $.patches == 2
  Examples:
    |roomSize|
    |[5,5]   |
    |[6,6]   |
    |[7,7]   |

#Invalid Values
  Scenario: Validate error is displayed when patches are outside the roomSize
    Given url 'http://localhost:8080/v1/cleaning-sessions'
    And request {"roomSize" : [3,3], "coords" : [1,2], "patches" : [[1,0],[2,2],[3,3]], "instructions" : "NNNNNNESEESWNWW"}
    When method POST
    Then status 400

  Scenario: Validate error is displayed when start point is outside the roomSize
    Given url 'http://localhost:8080/v1/cleaning-sessions'
    And request {"roomSize" : [3,3], "coords" : [1,3], "patches" : [[1,0],[2,2],[3,3]], "instructions" : "NNNNNNESEESWNWW"}
    When method POST
    Then status 400

  Scenario: Validate no negative values are accepted for roomSize
    Given url 'http://localhost:8080/v1/cleaning-sessions'
    And request {"roomSize" : [-3,-3], "coords" : [1,3], "patches" : [[1,0],[2,2],[3,3]], "instructions" : "NNNNNNESEESWNWW"}
    When method POST
    Then status 400

  Scenario: Validate no negative values are accepted for start point
    Given url 'http://localhost:8080/v1/cleaning-sessions'
    And request {"roomSize" : [3,3], "coords" : [-1,-3], "patches" : [[1,0],[2,2],[3,3]], "instructions" : "NNNNNNESEESWNWW"}
    When method POST
    Then status 400

#Missing Parameters
  Scenario: Validate missing roomSize error
    Given url 'http://localhost:8080/v1/cleaning-sessions'
    And request {"coords" : [-1,-3], "patches" : [[1,0],[2,2],[3,3]], "instructions" : "NNNNNNESEESWNWW"}
    When method POST
    Then status 400

  Scenario: Validate missing coords error
    Given url 'http://localhost:8080/v1/cleaning-sessions'
    And request {"roomSize" : [3,3], "patches" : [[1,0],[2,2],[3,3]], "instructions" : "NNNNNNESEESWNWW"}
    When method POST
    Then status 400

  Scenario: Validate missing patches error
    Given url 'http://localhost:8080/v1/cleaning-sessions'
    And request {"roomSize" : [3,3], "coords" : [-1,-3], "instructions" : "NNNNNNESEESWNWW"}
    When method POST
    Then status 400

  Scenario: Validate missing instructions error
    Given url 'http://localhost:8080/v1/cleaning-sessions'
    And request {"roomSize" : [3,3], "coords" : [-1,-3], "patches" : [[1,0],[2,2],[3,3]]}
    When method POST
    Then status 400

#Invalid API Calls
  Scenario: Validate error is displayed for wrong path
    Given url 'http://localhost:8080/v1/cleaning-sessionsss'
    And request {"roomSize" : [3,3], "coords" : [1,2], "patches" : [[1,0],[2,2],[3,3]], "instructions" : "NNNNNNESEESWNWW"}
    When method POST
    Then status 404
    And match $.error == "Not Found"

  Scenario: Validate error is displayed for wrong method
    Given url 'http://localhost:8080/v1/cleaning-sessions'
    And request {"roomSize" : [3,3], "coords" : [1,2], "patches" : [[1,0],[2,2],[3,3]], "instructions" : "NNNNNNESEESWNWW"}
    When method GET
    Then status 405
    And match $.error == "Method Not Allowed"

  Scenario: Validate error for missing body
    Given url 'http://localhost:8080/v1/cleaning-sessions'
    And request {}
    When method POST
    Then status 400
