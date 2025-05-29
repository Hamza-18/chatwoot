/* global axios */
import ApiClient from '../ApiClient';

class CaptainResponses extends ApiClient {
  constructor() {
    super('captain/topic_responses', { accountScoped: true });
  }

  get({ page = 1, searchKey, topicId, documentId, status } = {}) {
    return axios.get(this.url, {
      params: {
        page,
        searchKey,
        topic_id: topicId,
        document_id: documentId,
        status,
      },
    });
  }
}

export default new CaptainResponses();
