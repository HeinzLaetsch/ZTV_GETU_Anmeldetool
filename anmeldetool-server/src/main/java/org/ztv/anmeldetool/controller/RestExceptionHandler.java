package org.ztv.anmeldetool.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;
import org.ztv.anmeldetool.exception.AccessDeniedException;
import org.ztv.anmeldetool.exception.NotFoundException;
import org.ztv.anmeldetool.service.ServiceException;

import java.util.NoSuchElementException;

@ControllerAdvice
@Slf4j
public class RestExceptionHandler extends ResponseEntityExceptionHandler {
  @ExceptionHandler(AccessDeniedException.class)
  protected ResponseEntity<Object> handleAccessDenied(AccessDeniedException ex) {
    log.warn(ex.getMessage());
    return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
  }

  @ExceptionHandler(NotFoundException.class)
  protected ResponseEntity<Object> handleEntityNotFound(NotFoundException ex) {
    log.warn(ex.getMessage());
    return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ex.getMessage());
  }

  @ExceptionHandler(NoSuchElementException.class)
  protected ResponseEntity<Object> handleElementNotFound(NoSuchElementException ex) {
    log.warn(ex.getMessage());
    return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ex.getMessage());
  }

  @ExceptionHandler(ServiceException.class)
  protected ResponseEntity<Object> handleServiceException(ServiceException ex) {
    log.warn("Service exception: {}", ex.getMessage());
    return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(ex.getMessage());
  }

  @ExceptionHandler(Exception.class)
  protected ResponseEntity<Object> handleAllExceptions(Exception ex) {
    log.error("An unexpected error occurred", ex);
    return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("An internal server error occurred.");
  }
}
