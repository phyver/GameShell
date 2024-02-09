import logging


def logger_config(module):
    """
    Logger function. Extends Python loggin module and set a custom config.
    params: Module Name. e.i: logger_config(__name__).
    return: Custom logger_config Object.
    """
    formatter = logging.Formatter("%(asctime)s %(levelname)s %(message)s")
    handler = logging.StreamHandler()
    handler.setFormatter(formatter)

    custom_logger = logging.getLogger(module)
    custom_logger.setLevel(logging.DEBUG)

    custom_logger.addHandler(handler)

    return custom_logger
